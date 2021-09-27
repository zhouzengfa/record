# 利用dmesg和addr2line来对段错误进行调试

#####  一、测试环境：把如下代码保存为tst.cpp

```c++
int main(void)
{
    int*p= NULL;

    *p = 1;
    return 0;
}
```

##### 二、编译为可执行文件

```shell
g++ -g tst.cpp
```

##### 三、用**dmesg**  查看程序崩溃时，在内核中保存的相关信息

```shell
mike@root123-PowerEdge-R730:~$ dmesg -T | grep a.out
[四 1月 28 13:54:27 2021] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=48
[一 9月 27 17:56:50 2021] a.out[32054]: segfault at 0 ip 0000555f56d7c74a sp 00007ffe2f8a2970 error 6 in a.out[555f56d7c000+1000]
```

输出信息内容：段错误发生的时间（**[一 9月 27 17:56:50 2021]**）、发生段错误的程序名称[进程号]（**varnishd[16470]**）、引起段错误发生的指令指针地址（general protection ip:**0000555f56d7c74a**）、引起段错误发生的堆栈指针地址（sp:**00007ffe2f8a2970**）、错误代码（error:**6**）、[555f56d7c000+1000] 对象崩溃时映射的虚拟内存起始地址和大小

错误代码如下:

|      | 1                                         | 0                                                         |
| ---- | ----------------------------------------- | --------------------------------------------------------- |
| bit2 | 值为1表示是用户态程序内存访问越界         | 值为0表示是内核态程序内存访问越界                         |
| bit1 | 值为1表示是写操作导致内存访问越界         | 值为0表示是读操作导致内存访问越界                         |
| bit0 | 值为1表示没有足够的权限访问非法地址的内容 | 值为0表示访问的非法地址根本没有对应的页面，也就是无效地址 |

如：error 6 转化为二进制后为110，则bit2=1、bit1=1、bit0=0，表示用户态写操作无效地址

##### 四、利用addr2line定位

```shell
ip:0000555f56d7c74a -555f56d7c000 = 74a
```

```shell
mike@root123-PowerEdge-R730:~$ addr2line -e a.out 74a -f
main
/data/mike/tst.cpp:38
```

##### 五、利用objdump进行定位

```shell
mike@root123-PowerEdge-R730:~$ objdump -DSCgl a.out | grep -C 10 74a
/data/mike/tst.cpp:36
    int*p= NULL;
     73f:       00 00                   add    %al,(%rax)
     741:       1d 13 09 00 00          sbb    $0x913,%eax
/data/mike/tst.cpp:38
    *p = 1;
     746:       0f 4a 0c 04             cmovp  (%rsp,%rax,1),%ecx
     74a:       00 00                   add    %al,(%rax)
     74c:       36 07                   ss (bad)
     74e:       00 00                   add    %al,(%rax)
```

