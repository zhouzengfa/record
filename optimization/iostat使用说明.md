# iostat 使用
##### 1. 命令格式
```
iostat[参数][时间][次数]
```

##### 3. 命令参数
```	
-C 显示CPU使用情况
-d 显示磁盘使用情况
-k 以 KB 为单位显示
-m 以 M 为单位显示
-N 显示磁盘阵列(LVM) 信息
-n 显示NFS 使用情况
-p[磁盘] 显示磁盘和分区的情况
-t 显示终端和CPU的信息
-x 显示详细信息
-V 显示版本信息
```
##### 4. 工具实例
* 4.1 显示所有设备负载情况

```
[root@localhost /]# iostat
Linux 3.10.0-862.el7.x86_64 (localhost.localdomain)     06/13/2020      _x86_64_        (4 CPU)

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.09    0.00    0.17    0.02    0.00   99.71

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
scd0              0.00         0.00         0.00       1028          0
sda               0.39        12.83        11.70   37025804   33769479
dm-0              0.42        11.75        10.46   33927333   30200642
dm-1              0.57         1.06         1.24    3071508    3566448

```
##### cpu属性值说明：
```
%user：CPU处在用户模式下的时间百分比。
%nice：CPU处在带NICE值的用户模式下的时间百分比。
%system：CPU处在系统模式下的时间百分比。
%iowait：CPU等待输入输出完成时间的百分比。
%steal：管理程序维护另一个虚拟处理器时，虚拟CPU的无意识等待时间百分比。
%idle：CPU空闲时间百分比。
```
##### device属性值说明
```
tps：该设备每秒的传输次数（Indicate the number of transfers per second that were issued to the device.）。“一次传输”意思是“一次I/O请求”。多个逻辑请求可能会被合并为“一次I/O请求”。“一次传输”请求的大小是未知的。
kB_read/s：每秒从设备（drive expressed）读取的数据量；
kB_wrtn/s：每秒向设备（drive expressed）写入的数据量；
kB_read：读取的总数据量；kB_wrtn：写入的总数量数据量；
```

* 4.2 查看设备使用率（%util）和响应时间（await） 

```
[root@localhost /]# iostat -d -x -k 1 1
Linux 3.10.0-862.el7.x86_64 (localhost.localdomain)     06/13/2020      _x86_64_        (4 CPU)

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
scd0              0.00     0.00    0.00    0.00     0.00     0.00   114.22     0.00   20.56   20.56    0.00  20.28   0.00
sda               0.23     0.38    0.19    0.20    12.82    11.70   126.01     0.02   43.43   41.63   45.21   1.60   0.06
dm-0              0.00     0.00    0.16    0.27    11.75    10.46   104.74     0.03   75.38   50.96   89.91   1.37   0.06
dm-1              0.00     0.00    0.27    0.31     1.06     1.24     8.00     0.11  190.05    7.01  347.59   0.35   0.02

```
##### 参数说明
```
rrqm/s： 每秒进行 merge 的读操作数目.即 delta(rmerge)/s
wrqm/s： 每秒进行 merge 的写操作数目.即 delta(wmerge)/s
r/s： 每秒完成的读 I/O 设备次数.即 delta(rio)/s
w/s： 每秒完成的写 I/O 设备次数.即 delta(wio)/s
rsec/s： 每秒读扇区数.即 delta(rsect)/s
wsec/s： 每秒写扇区数.即 delta(wsect)/s
rkB/s： 每秒读K字节数.是 rsect/s 的一半,因为每扇区大小为512字节.(需要计算)
wkB/s： 每秒写K字节数.是 wsect/s 的一半.(需要计算)
avgrq-sz：平均每次设备I/O操作的数据大小 (扇区).delta(rsect+wsect)/delta(rio+wio)
avgqu-sz：平均I/O队列长度.即 delta(aveq)/s/1000 (因为aveq的单位为毫秒).
await： 平均每次设备I/O操作的等待时间 (毫秒).即 delta(ruse+wuse)/delta(rio+wio)
svctm： 平均每次设备I/O操作的服务时间 (毫秒).即 delta(use)/delta(rio+wio)
%util： 一秒中有百分之多少的时间用于 I/O 操作,或者说一秒中有多少时间 I/O 队列是非空的，即 delta(use)/s/1000 (因为use的单位为毫秒)
```
备注：如果 %util 接近 100%，说明产生的I/O请求太多，I/O系统已经满负荷，该磁盘可能存在瓶颈。如果 svctm 比较接近 await，说明 I/O 几乎没有等待时间；如果 await 远大于 svctm，说明I/O 队列太长，io响应太慢，需要进行必要优化，可以考虑更换更快的磁盘，调整内核 elevator 算法，优化应用，或者升级 CPU。如果avgqu-sz比较大，也表示有相当量io在等待。