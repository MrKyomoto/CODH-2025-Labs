module CPU (
    input                   [ 0 : 0]            clk,
    input                   [ 0 : 0]            rst,

    input                   [ 0 : 0]            global_en,

/* ------------------------------ Memory (inst) ----------------------------- */
    output                  [31 : 0]            imem_raddr,
    input                   [31 : 0]            imem_rdata,

/* ------------------------------ Memory (data) ----------------------------- */
    input                   [31 : 0]            dmem_rdata,
    output                  [ 0 : 0]            dmem_we,
    output                  [31 : 0]            dmem_addr,
    output                  [31 : 0]            dmem_wdata,

/* ---------------------------------- Debug --------------------------------- */
    output                  [ 0 : 0]            commit,
    output                  [31 : 0]            commit_pc,
    output                  [31 : 0]            commit_inst,
    output                  [ 0 : 0]            commit_halt,
    output                  [ 0 : 0]            commit_reg_we,
    output                  [ 4 : 0]            commit_reg_wa,
    output                  [31 : 0]            commit_reg_wd,
    output                  [ 0 : 0]            commit_dmem_we,
    output                  [31 : 0]            commit_dmem_wa,
    output                  [31 : 0]            commit_dmem_wd,

    input                   [ 4 : 0]            debug_reg_ra,   // TODO
    output                  [31 : 0]            debug_reg_rd    // TODO
);

wire [31:0] pcIn;
reg [31:0] pcIn_reg;
wire [31:0] pcOut;
wire [31:0] pcAdd4;

wire [4:0] rs1; 
wire [4:0] rs2; 
wire [4:0] rd; // register destination
wire [11:0] imm12;
wire [19:0] imm20;
wire [2:0] sel_branch;
wire se_type;
wire isHalt;
wire [5:0] opType;

wire [31:0] rd1; //register data 1
wire [31:0] rd2; //register data 2

wire [31:0] imm32;

wire pcMux;
wire src1Mux;
wire src2Mux;
wire write2RfMux;
wire isJump;
wire write2RfEn;
wire write2DMEn;
wire [3:0] aluSel;

wire cmpResult;

wire [31:0] src1;
wire [31:0] src2;
wire [31:0] aluOut;
wire [1:0] addrOffset;

wire [31:0] jumpMuxOut; //这个是aluOut和pcAdd4之间又加了一个MUX,专门服务JAL和JALR两条指令

wire [31:0] writeData_rf;

wire [31:0] dmem_rdata_filtered;
wire [31:0] dmem_wdata_filtered;

wire storeFilterEn;
always @(*) begin
    pcIn_reg = pcIn; 
end

assign addrOffset = aluOut[1:0];
PC pc(
    .clk(clk),
    .rst(rst),
    .en(global_en),
    .pcIn(pcIn_reg),
    .pcOut(pcOut)
);
ADDER adder4(
    .in1(pcOut),
    .in2(32'd4),
    .out(pcAdd4)
);

assign imem_raddr = pcOut; 

MUX2 pcmux(
    .in1(pcAdd4),
    .in2(aluOut),
    .sel(pcMux),
    .out(pcIn)
);

Decoder decoder(
    .IR(imem_rdata),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .imm12(imm12),
    .imm20(imm20),
    .sel_branch(sel_branch),
    .se_type(se_type),
    .isHalt(isHalt),
    .opType(opType)
);

RF rf(
    .clk(clk),
    .ra0(rs1),
    .ra1(rs2),
    .rd0(rd1),
    .rd1(rd2),
    .wa(rd),
    .wd(writeData_rf), 
    .we(write2RfEn),
    .debug_ra(debug_reg_ra),
    .debug_rd(debug_reg_rd)
);

SE se(
    .se_type(se_type),
    .opType(opType),
    .imm12(imm12),
    .imm20(imm20),
    .imm32(imm32)
);

CTRL ctrl(
    .opType(opType),
    .cmpResult(cmpResult),
    .pcMux(pcMux),
    .src1Mux(src1Mux),
    .src2Mux(src2Mux),
    .write2RfMux(write2RfMux),
    .isJump(isJump),
    .write2RfEn(write2RfEn),
    .write2DMEn(write2DMEn),
    .aluSel(aluSel)
);

CMP cmp(
    .in1(rd1),
    .in2(rd2),
    .sel(sel_branch),
    .result(cmpResult)
);

MUX2 src1mux(
    .in1(pcOut),
    .in2(rd1),
    .sel(src1Mux),
    .out(src1)
);
MUX2 src2mux(
    .in1(rd2),
    .in2(imm32),
    .sel(src2Mux),
    .out(src2)
);

ALU alu(
    .in1(src1),
    .in2(src2),
    .op(aluSel),
    .out(aluOut)
);

MUX2 jumpMux(
    .in1(aluOut),
    .in2(pcAdd4),
    .sel(isJump),
    .out(jumpMuxOut)
);

LoadFilter filter(
    .in(dmem_rdata),
    .opType(opType),
    .offset(addrOffset),
    .out(dmem_rdata_filtered)
);

StoreFilter storeFilter(
    .srcRf(rd2),
    .srcDm(dmem_rdata),
    .opType(opType),
    .offset(addrOffset),
    .wdata(dmem_wdata_filtered),
    .we(storeFilterEn)
);

assign dmem_wdata = dmem_wdata_filtered;

MUX2 write2RF(
    .in1(jumpMuxOut),
    .in2(dmem_rdata_filtered),
    .sel(write2RfMux),
    .out(writeData_rf)
);

assign dmem_we = write2DMEn && storeFilterEn;
assign dmem_addr = aluOut;

    // Commit
    reg  [ 0 : 0]   commit_reg          ;
    reg  [31 : 0]   commit_pc_reg       ;
    reg  [31 : 0]   commit_inst_reg     ;
    reg  [ 0 : 0]   commit_halt_reg     ;
    reg  [ 0 : 0]   commit_reg_we_reg   ;
    reg  [ 4 : 0]   commit_reg_wa_reg   ;
    reg  [31 : 0]   commit_reg_wd_reg   ;
    reg  [ 0 : 0]   commit_dmem_we_reg  ;
    reg  [31 : 0]   commit_dmem_wa_reg  ;
    reg  [31 : 0]   commit_dmem_wd_reg  ;

    // Commit
    always @(posedge clk) begin
        if (rst) begin
            commit_reg          <= 1'B0;
            commit_pc_reg       <= 32'H0;
            commit_inst_reg     <= 32'H0;
            commit_halt_reg     <= 1'B0;
            commit_reg_we_reg   <= 1'B0;
            commit_reg_wa_reg   <= 5'H0;
            commit_reg_wd_reg   <= 32'H0;
            commit_dmem_we_reg  <= 1'B0;
            commit_dmem_wa_reg  <= 32'H0;
            commit_dmem_wd_reg  <= 32'H0;
        end
        else if (global_en) begin
            commit_reg          <= 1'B1;
            commit_pc_reg       <= pcOut;   // TODO
            commit_inst_reg     <= imem_rdata;   // TODO
            commit_halt_reg     <= isHalt;   // TODO
            commit_reg_we_reg   <= write2RfEn;   // TODO
            commit_reg_wa_reg   <= rd;   // TODO
            commit_reg_wd_reg   <= writeData_rf;   // TODO
            commit_dmem_we_reg  <= write2DMEn && storeFilterEn;   // TODO
            commit_dmem_wa_reg  <= aluOut;   // TODO
            commit_dmem_wd_reg  <= dmem_wdata_filtered;   // TODO
        end
    end

    assign commit           = commit_reg;
    assign commit_pc        = commit_pc_reg;
    assign commit_inst      = commit_inst_reg;
    assign commit_halt      = commit_halt_reg;
    assign commit_reg_we    = commit_reg_we_reg;
    assign commit_reg_wa    = commit_reg_wa_reg;
    assign commit_reg_wd    = commit_reg_wd_reg;
    assign commit_dmem_we   = commit_dmem_we_reg;
    assign commit_dmem_wa   = commit_dmem_wa_reg;
    assign commit_dmem_wd   = commit_dmem_wd_reg;

endmodule