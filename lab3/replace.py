# 为了适配putty而写的小脚本,请自行修改A和B的文件路径(绝对路径)
# 打开原始文件A进行读取
with open('g:\\.CS\\COD\\risc-v\\lab3_2.txt', 'r') as fileA:
    # 读取文件内容并替换换行符为空格
    content = fileA.read().replace('\n', ' ')

# 打开新的文件B进行写入
with open('g:\\.CS\\COD\\risc-v\\lab3_2_mod.txt', 'w') as fileB:
    # 写入修改后的内容到文件B
    fileB.write(content)
