# awk 命令
##### 1.设置分隔符
* 使用“，”分割
		awk -F, '{print $1,$2}' log.txt
* 使用内建变量
		awk 'BEGIN{FS=","} {print $1,$2}'     log.txt
* 使用多个分隔符.先使用空格分割，然后对分割结果再使用","分割
 		awk -F '[ ,]'  '{print $1,$2,$5}'   log.txt

##### 2.设置变量
	awk -va=1 '{print $1,$1+a}' log.txt

##### 3.使用awk脚本 
	awk -f {awk脚本} {文件名}

##### 4.使用运算符
* 过滤第一列大于2并且第二列等于'Are'的行
		awk '$1>2 && $2=="Are" {print $1,$2,$3}' log.txt

##### 5.使用正则，字符串匹配
* 输出第二列包含 "th"，并打印第二列与第四列
		awk '$2 ~ /th/ {print $2,$4}' log.txt
* 输出包含"re" 的行
		awk '/re/ ' log.txt
* 模式取反
		awk '$2 !~ /th/ {print $2,$4}' log.txt
		awk '!/th/ {print $2,$4}' log.txt

##### 6.awk脚本
```shell
$ cat score.txt
Marry   2143 78 84 77
Jack    2321 66 78 45
Tom     2122 48 77 71
Mike    2537 87 97 95
Bob     2415 40 57 62
```
awk 脚本
假设有这么一个文件（学生成绩表）：
```shell
#!/bin/awk -f
#运行前
BEGIN {
    math = 0
    english = 0
    computer = 0
 
    printf "NAME    NO.   MATH  ENGLISH  COMPUTER   TOTAL\n"
    printf "---------------------------------------------\n"
}
#运行中
{
    math+=$3
    english+=$4
    computer+=$5
    printf "%-6s %-6s %4d %8d %8d %8d\n", $1, $2, $3,$4,$5, $3+$4+$5
}
#运行后
END {
    printf "---------------------------------------------\n"
    printf "  TOTAL:%10d %8d %8d \n", math, english, computer
    printf "AVERAGE:%10.2f %8.2f %8.2f\n", math/NR, english/NR, computer/NR
}
```

##### 7.条件语句
* if语句 语法 与c++语法类似
```shell
if (condition)
    action
```
也可以使用花括号来执行一组操作：
```shell
if (condition)
{
    action-1
    action-1
    .
    .
    action-n
}
```
以下实例用来判断数字是奇数还是偶数：
```shell
$ awk 'BEGIN {num = 10; if (num % 2 == 0) printf "%d 是偶数\n", num }'
```


参考文档
1.https://www.runoob.com/linux/linux-comm-awk.html
2.https://www.runoob.com/w3cnote/awk-if-loop.html