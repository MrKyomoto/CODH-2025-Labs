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
// wire isJump;
wire [1:0] write2RfMux;
wire write2RfEn;
wire write2DMEn;
wire [3:0] aluSel;

wire [31:0] src1;
wire [31:0] src2;
wire [31:0] aluOut;
wire [1:0] addrOffset;

wire [31:0] writeData_rf;

wire [31:0] dmem_rdata_filtered;
wire [31:0] dmem_wdata_filtered;

wire storeFilterEn;
always @(*) begin
    pcIn_reg = pcIn; 
end

assign addrOffset = eY[1:0];

wire fStall, fFlush, dStall, dFlush, eStall, eFlush, mStall, mFlush;
wire [31:0] fIR, fPC, dIR, dPC, eIR, ePC, mIR, mPC;
wire [4:0] dRs1, dRs2, dRd, eRs1, eRs2, eRd, mRs1, mRs2, mRd;
wire dWB, eWB, mWB;
wire [1:0] dWBMux, eWBMux, mWBMux;
wire dMW, eMW;
wire [3:0] dEX;
wire [31:0] dA, dB;

wire [31:0] eMDW;
wire [31:0] eY, mY;

wire [31:0] mMDR;

wire dSrc1mux, dSrc2mux;
wire [31:0] dImm32;
wire [5:0] dOptype, eOptype;
wire [2:0] dSel_branch;

wire mMW;
wire fCommit, dCommit, dIsHalt, eCommit, eIsHalt, mCommit, mIsHalt;
wire pcFlush, pcStall;

wire mStoreFilterEn;
wire [31:0] mDmem_wdata_filtered;

wire [1:0] forwardMux1, forwardMux2;

wire [31:0] cmpSrc1, cmpSrc2;

wire tempFlush;

wire [31:0] subSrc2;
//DONE(flush和stall信号要连起来,已经连起来了)
UReg IFID(
    .clk(clk),
    .rstn(~rst),
    .en(global_en),
    .stall(fStall),
    .flush(fFlush),
    .IR(imem_rdata),
    .PC(pcAdd4),
    .rs1(5'b0),
    .rs2(5'b0),
    .rd(5'b0),
    .MDW(32'b0),
    .MDR(32'b0),
    .WB(1'b0),
    .WBMux(2'b0),
    .MW(1'b0),
    .EX(4'b0),
    .Y(32'b0),
    .A(32'b0),
    .B(32'b0),

    .IRout(fIR),
    .PCout(fPC),
    .rs1out(),
    .rs2out(),
    .rdout(),
    .MDWout(),
    .MDRout(),
    .WBout(),
    .WBMuxout(),
    .MWout(),
    .EXout(),
    .Aout(),
    .Bout(),
    .YW(),

    .src1Mux(1'b0),
    .src2Mux(1'b0),
    .src1Muxout(),
    .src2Muxout(),
    .imm32(32'b0),
    .imm32out(),

    .opType(6'b0),
    .opTypeOut(),
    .sel_branch(3'b0),
    .sel_branch_out(),

    .commit(1'b1),
    .isHalt(1'b0),
    .commitOut(fCommit),
    .isHaltOut(),

    .storeFilteredEn(1'b0),
    .storeFilteredEnOut(),
    .storeDataFiltered(32'b0),
    .storeDataFilteredOut()
);

UReg IDEX(
    .clk(clk),
    .rstn(~rst),
    .en(global_en),
    .stall(dStall),
    .flush(dFlush),
    .IR(fIR),
    .PC(fPC),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .MDW(32'b0),
    .MDR(32'b0),
    .WB(write2RfEn),
    .WBMux(write2RfMux),
    .MW(write2DMEn),
    .EX(aluSel),
    .Y(32'b0),
    .A(rd1),
    .B(rd2),

    .IRout(dIR),
    .PCout(dPC),
    .rs1out(dRs1),
    .rs2out(dRs2),
    .rdout(dRd),
    .MDWout(),
    .MDRout(),
    .WBout(dWB),
    .WBMuxout(dWBMux),
    .MWout(dMW),
    .EXout(dEX),
    .Aout(dA),
    .Bout(dB),
    .YW(),

    .src1Mux(src1Mux),
    .src2Mux(src2Mux),
    .src1Muxout(dSrc1mux),
    .src2Muxout(dSrc2mux),

    .imm32(imm32),
    .imm32out(dImm32),

    .opType(opType),
    .opTypeOut(dOptype),
    .sel_branch(sel_branch),
    .sel_branch_out(dSel_branch),


    .commit(fCommit),
    .isHalt(isHalt),
    .commitOut(dCommit),
    .isHaltOut(dIsHalt),

    .storeFilteredEn(1'b0),
    .storeFilteredEnOut(),
    .storeDataFiltered(32'b0),
    .storeDataFilteredOut()
);

UReg EXMEM(
    .clk(clk),
    .rstn(~rst),
    .en(global_en),
    .stall(eStall),
    .flush(eFlush),
    .IR(dIR),
    .PC(dPC),
    .rs1(dRs1),
    .rs2(dRs2),
    .rd(dRd),
    .MDW(subSrc2),
    .MDR(32'b0),
    .WB(dWB),
    .WBMux(dWBMux),
    .MW(dMW),
    .EX(dEX),
    .Y(aluOut),
    .A(dA),
    .B(dB),

    .IRout(eIR),
    .PCout(ePC),
    .rs1out(eRs1),
    .rs2out(eRs2),
    .rdout(eRd),
    .MDWout(eMDW),
    .MDRout(),
    .WBout(eWB),
    .WBMuxout(eWBMux),
    .MWout(eMW),
    .EXout(),
    .Aout(),
    .Bout(),
    .YW(eY),

    .src1Mux(dSrc1mux),
    .src2Mux(dSrc2mux),
    .src1Muxout(),
    .src2Muxout(),
    
    .imm32(32'b0),
    .imm32out(),

    .opType(dOptype),
    .opTypeOut(eOptype),
    .sel_branch(3'b0),
    .sel_branch_out(),

    .commit(dCommit),
    .isHalt(dIsHalt),
    .commitOut(eCommit),
    .isHaltOut(eIsHalt),

    .storeFilteredEn(1'b0),
    .storeFilteredEnOut(),
    .storeDataFiltered(32'b0),
    .storeDataFilteredOut()
);

UReg MEMWB(
    .clk(clk),
    .rstn(~rst),
    .en(global_en),
    .stall(mStall),
    .flush(mFlush),
    .IR(eIR),
    .PC(ePC),
    .rs1(eRs1),
    .rs2(eRs2),
    .rd(eRd),
    .MDW(32'b0),
    .MDR(dmem_rdata_filtered),
    .WB(eWB),
    .WBMux(eWBMux),
    .MW(eMW),
    .EX(4'b0),
    .Y(eY),
    .A(32'b0),
    .B(32'b0),

    .IRout(mIR),
    .PCout(mPC),
    .rs1out(mRs1),
    .rs2out(mRs2),
    .rdout(mRd),
    .MDWout(),
    .MDRout(mMDR),
    .WBout(mWB),
    .WBMuxout(mWBMux),
    .MWout(mMW),
    .EXout(),
    .Aout(),
    .Bout(),
    .YW(mY),

    .src1Mux(1'b0),
    .src2Mux(1'b0),
    .src1Muxout(),
    .src2Muxout(),

    .imm32(32'b0),
    .imm32out(),


    .opType(eOptype),
    .opTypeOut(),
    .sel_branch(3'b0),
    .sel_branch_out(),

    .commit(eCommit),
    .isHalt(eIsHalt),
    .commitOut(mCommit),
    .isHaltOut(mIsHalt),

    .storeFilteredEn(storeFilterEn),
    .storeFilteredEnOut(mStoreFilterEn),
    .storeDataFiltered(dmem_wdata_filtered),
    .storeDataFilteredOut(mDmem_wdata_filtered)
);

assign fFlush = pcMux;
assign dFlush = pcMux || tempFlush;//TODO(感觉可能不太对,又说不上来哪里不对,因为pcMux是否能确保只在B型和J型的时候才为1)
PC pc(
    .clk(clk),
    .rst(rst),
    .en(global_en),
    .flush(pcFlush),
    .stall(pcStall),
    .pcIn(pcIn_reg),
    .pcOut(pcOut)
);

LUHazard luhazard(
    .dOptype(dOptype),
    .dRd(dRd),
    .fRs1(rs1),
    .fRs2(rs2),
    .pcStall(pcStall),
    .fStall(fStall),
    //MEMO(因为dFlush除了在这种逻辑里会变成1,跳转成功的时候也会变成1)
    .dFlush(tempFlush)
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
    .IR(fIR),
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
    .wa(mRd),
    .wd(writeData_rf), 
    .we(mWB),
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
    .src1Mux(src1Mux),
    .src2Mux(src2Mux),
    // .isJump(isJump),
    .write2RfMux(write2RfMux),
    .write2RfEn(write2RfEn),
    .write2DMEn(write2DMEn),
    .aluSel(aluSel)
);

MUX3 cmpSrc1mux(
    .in1(dA),
    .in2(eY),
    .in3(writeData_rf),
    .sel(forwardMux1),
    .out(cmpSrc1)
);
MUX3 cmpSrc2mux(
    .in1(dB),
    .in2(eY),
    .in3(writeData_rf),
    .sel(forwardMux2),
    .out(cmpSrc2)
);
CMP cmp(
    .in1(cmpSrc1),
    .in2(cmpSrc2),
    .sel(dSel_branch),
    .opType(dOptype),//TODO(已完成)
    .result(pcMux)
);

//MEMO(前递模块既服务于alu,也服务于branch(cmp))
FU fu(
    .eWB(eWB),
    .mWB(mWB),
    .eRd(eRd),
    .mRd(mRd),
    .dRs1(dRs1),
    .dRs2(dRs2),
    .eWBMux(eWBMux),
    .forwardMux1(forwardMux1),
    .forwardMux2(forwardMux2)
);

FUMux4 src1mux(
    .in1(dPC - 4),
    .in2(dA),
    .in3(eY),
    .in4(writeData_rf),
    .sel1(dSrc1mux),
    .sel2(forwardMux1),
    .out(src1)
);
//MEMO(src2的选择跟src1稍有不同,因此他们并不能公用一个FUMux4,具体原因是src2这边还有一个立即数的问题,遇到store指令的时候要传递的是rd2,但进入alu的是imm32,如果公用一个FUMux就会出现alu的in2和传递的值只能相等,这并不是我们期望的(我感觉自己没说清楚,不过反正是这个理))
// FUMux4 src2mux(
//     .in1(dB),
//     .in2(dImm32),
//     .in3(eY),
//     .in4(writeData_rf),
//     .sel1(dSrc2mux),
//     .sel2(forwardMux2),
//     .out(subSrc2)
// );

//MEMO(我写的逻辑里,面对store指令的rs1和rs2都等于上一条指令的rd时,会出问题,虽然rs2=rd,但是这里进入alu运算的实际上是一个imm32,但我的逻辑里进入的却是rs2)
//MEMO(故而额外再加一个二选一)
MUX2 src2mux(
    .in1(subSrc2),
    .in2(dImm32),
    .sel(dSrc2mux),
    .out(src2)
);

MUX3 src2muxSub(
    .in1(dB),
    .in2(eY),
    .in3(writeData_rf),
    .sel(forwardMux2),
    .out(subSrc2)
);
// MUX2 src1mux(
//     //MEMO(涉及到PC参与的alu运算,输入应该是PC,但是短剑寄存器里存的是PC+4,因此要减掉4)
//     .in1(dPC - 4),
//     .in2(dA),
//     .sel(dSrc1mux),
//     .out(src1)
// );
// MUX2 src2mux(
//     .in1(dB),
//     .in2(dImm32),
//     .sel(dSrc2mux),
//     .out(src2)
// );

ALU alu(
    .in1(src1),
    .in2(src2),
    .op(dEX),
    .out(aluOut)
);

MUX3 write2RF(
    .in1(mY),
    .in2(mMDR),
    .in3(mPC),
    .sel(mWBMux),
    .out(writeData_rf)
);

LoadFilter filter(
    .in(dmem_rdata),
    .opType(eOptype),
    .offset(addrOffset),
    .out(dmem_rdata_filtered)
);

StoreFilter storeFilter(
    .srcRf(eMDW),
    .srcDm(dmem_rdata),
    .opType(eOptype),
    .offset(addrOffset),
    .wdata(dmem_wdata_filtered),
    .we(storeFilterEn)
);
//TODO(该处理跳转失败时候的事情了,以及commit系列信号如何处理,都还没做)

assign dmem_wdata = dmem_wdata_filtered;

assign dmem_we = eMW && storeFilterEn;
assign dmem_addr = eY;

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
            commit_reg          <= mCommit;
            commit_pc_reg       <= mPC - 4;   // TODO
            commit_inst_reg     <= mIR;   // TODO
            commit_halt_reg     <= mIsHalt;   // TODO
            commit_reg_we_reg   <= mWB;   // TODO
            commit_reg_wa_reg   <= mRd;   // TODO
            commit_reg_wd_reg   <= writeData_rf;   // TODO
            commit_dmem_we_reg  <= mMW && mStoreFilterEn;   // TODO
            commit_dmem_wa_reg  <= mY;   // TODO
            commit_dmem_wd_reg  <= mDmem_wdata_filtered;   // TODO
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
