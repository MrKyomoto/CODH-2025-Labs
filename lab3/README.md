# Intro
这是CODH 2025 LAB3的实现
- 位于CPU目录下的内容是自己写的单周期CPU及其附属模块
- PDU相关部分是助教提供的方便调试以及上版热写入数据|指令的模块
- MEM也是助教提供的
- 请自行在vivado中例化两个dist mem IP核,命名分别为INST_MEM和DATA_MEM,depth为512,width为32
- 注意物理开发板的rst是低电平复位,而FPGAOL是高电平复位,所以在不同平台上可能要修改TOP.v中有关rst的接口部分(其实就是取反与否的问题)
  - 如果用物理开发板,串口的波特率为9600(putty默认即为9600),以及需要注意的是putty中鼠标右键是粘贴
  - 串口指令请查看LAB3中附的PDU文档
- testIR中的十六进制代码为上板测试指令(RV32I),3_1为运算+跳转指令的测试;3_2为访存指令的测试
  - 带有mod字样的文件是为了适配putty的粘贴而写的,以及最后一条指令为ebreak(即halt)
  - 未带mod字样的为rars导出的源文件,以及最后一条指令为ebreak
- replace.py是为了适配putty而写的小脚本,用于将每行一条的指令转为以空格分割的指令
- TOP.v中的segment也是物理开发板的,如果想在FPGAOL跑,需要更换为FPGAOL对应的segment(约束文件也有所不同)