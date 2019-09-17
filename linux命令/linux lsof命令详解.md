# linux lsof命令

* 输出格式
```
[root@localhost Server]# lsof -c LoginServer | grep -v lib64
COMMAND     PID USER   FD      TYPE DEVICE  SIZE/OFF      NODE NAME
LoginServ 15676 root  cwd       DIR  253,2      4096 537302447 /home/dev/testServer/Server/bin
LoginServ 15676 root  rtd       DIR  253,0      4096        96 /
LoginServ 15676 root  txt       REG  253,2  50728336 537311280 /home/dev/testServer/Server/bin/LoginServer
LoginServ 15676 root  mem       REG  253,0 106075056      2113 /usr/lib/locale/locale-archive
LoginServ 15676 root    0r      CHR    1,3       0t0      1028 /dev/null
LoginServ 15676 root    1u      CHR 136,10       0t0        13 /dev/pts/10 (deleted)
LoginServ 15676 root    2u      CHR 136,10       0t0        13 /dev/pts/10 (deleted)
LoginServ 15676 root    3u      REG  253,2  59028900 269279808 /home/dev/testServer/Server/bin/log/Client11.txt
LoginServ 15676 root    4u     IPv4 744401       0t0       TCP localhost:50408->localhost:6379 (ESTABLISHED)
LoginServ 15676 root    5w      REG  253,2   3199199    116144 /home/dev/testServer/Server/bin/log_ls/info.log20190903-155948.15676
LoginServ 15676 root    6u  a_inode   0,10         0      6415 [eventpoll]
LoginServ 15676 root    7u     IPv4 743281       0t0       TCP *:raid-cc (LISTEN)
LoginServ 15676 root    8u     IPv4 722767       0t0       TCP localhost:raid-cc->localhost:50932 (ESTABLISHED)
LoginServ 15676 root    9w      REG  253,2    227135 269279809 /home/dev/testServer/Server/bin/log/accept.txt
LoginServ 15676 root   10u      REG  253,2   5379363 269279810 /home/dev/testServer/Server/bin/log/ErrorNet.txt.txt
LoginServ 15676 root   11u      REG  253,2     13146 268549148 /home/dev/testServer/Server/bin/log/kfifo_15676.txt
```
lsof输出各列信息的意义如下：
```
COMMAND：进程的名称 PID：进程标识符
USER：进程所有者
FD：文件描述符，应用程序通过文件描述符识别该文件。如cwd、txt等,后面说明 
TYPE：文件类型，如DIR、REG等
DEVICE：指定磁盘的名称
SIZE：文件的大小
NODE：索引节点（文件在磁盘上的标识）
NAME：打开文件的确切名称
FD 列中的文件描述符cwd 值表示应用程序的当前工作目录，这是该应用程序启动的目录，除非它本身对这个目录进行更改,txt 类型的文件是程序代码，如应用程序二进制文件本身或共享库;其次数值表示应用程序的文件描述符，这是打开该文件时返回的一个整数。如上的最后一行文件/dev/pts/10，其文件描述符为 1。u 表示该文件被打开并处于读取/写入模式，而不是只读(r)或只写 (w) 模式。同时还有大写 的 W 表示该应用程序具有对整个文件的写锁。该文件描述符用于确保每次只能打开一个应用程序实例。初始打开每个应用程序时，都具有三个文件描述符，从 0 到 2，分别表示标准输入、输出和错误流。所以大多数应用程序所打开的文件的 FD 都是从 3 开始。
与 FD 列相比，Type 列则比较直观。文件和目录分别称为 REG 和 DIR。而CHR 和 BLK，分别表示字符和块设备；或者 UNIX、FIFO 和 IPv4，分别表示 UNIX 域套接字、先进先出 (FIFO) 队列和网际协议 (IP) 套接字。
```
* 常用参数
lsof语法格式是： lsof ［options］ filename
```
lsof abc.txt 显示开启文件abc.txt的进程 
lsof -c abc 显示abc进程现在打开的文件 
lsof -c -p 1234 列出进程号为1234的进程所打开的文件 
lsof -g gid 显示归属gid的进程情况 
lsof +d /usr/local/ 显示目录下被进程开启的文件 
lsof +D /usr/local/ 同上，但是会搜索目录下的目录，时间较长 
lsof -d 4 显示使用fd为4的进程 
lsof -i 用以显示符合条件的进程情况
```

* lsof使用实例
查找谁在使用文件系统
在卸载文件系统时，如果该文件系统中有任何打开的文件，操作通常将会失败。那么通过lsof可以找出那些进程在使用当前要卸载的文件系统，如下：
``` 
# lsof /GTES11/ 
COMMAND PID USER FD TYPE DEVICE SIZE NODE NAME 
bash 4208 root cwd DIR 3,1 4096 2 /GTES11/ 
vim 4230 root cwd DIR 3,1 4096 2 /GTES11/ 
```
在这个示例中，用户root正在其/GTES11目录中进行一些操作。一个 bash是实例正在运行，并且它当前的目录为/GTES11，另一个则显示的是vim正在编辑/GTES11下的文件。要成功地卸载/GTES11，应该在通知用户以确保情况正常之后，中止这些进程。 这个示例说明了应用程序的当前工作目录非常重要，因为它仍保持着文件资源，并且可以防止文件系统被卸载。这就是为什么大部分守护进程（后台进程）将它们的目录更改为根目录、或服务特定的目录（如 sendmail 示例中的 /var/spool/mqueue）的原因，以避免该守护进程阻止卸载不相关的文件系统。

* 主要用案例

```
1.列出所有打开的文件:
lsof
备注: 如果不加任何参数，就会打开所有被打开的文件，建议加上一下参数来具体定位

2. 查看谁正在使用某个文件
lsof   /filepath/file

3.递归查看某个目录的文件信息
lsof +D /filepath/filepath2/
备注: 使用了+D，对应目录下的所有子目录和文件都会被列出

4. 比使用+D选项，遍历查看某个目录的所有文件信息 的方法
lsof | grep ‘/filepath/filepath2/’

5. 列出某个用户打开的文件信息
lsof  -u username
备注: -u 选项，u其实是user的缩写

6. 列出某个程序所打开的文件信息
lsof -c mysql
备注: -c 选项将会列出所有以mysql开头的程序的文件，其实你也可以写成lsof | grep mysql,但是第一种方法明显比第二种方法要少打几个字符了

7. 列出多个程序多打开的文件信息
lsof -c mysql -c apache

8. 列出某个用户以及某个程序所打开的文件信息
lsof -u test -c mysql

9. 列出除了某个用户外的被打开的文件信息
lsof   -u ^root
备注：^这个符号在用户名之前，将会把是root用户打开的进程不让显示

10. 通过某个进程号显示该进行打开的文件
lsof -p 1

11. 列出多个进程号对应的文件信息
lsof -p 123,456,789

12. 列出除了某个进程号，其他进程号所打开的文件信息
lsof -p ^1

13 . 列出所有的网络连接
lsof -i

14. 列出所有tcp 网络连接信息
lsof  -i tcp

15. 列出所有udp网络连接信息
lsof  -i udp

16. 列出谁在使用某个端口
lsof -i :3306

17. 列出谁在使用某个特定的udp端口
lsof -i udp:55

特定的tcp端口
lsof -i tcp:80

18. 列出某个用户的所有活跃的网络端口
lsof  -a -u test -i

19. 列出所有网络文件系统
lsof -N

20..某个用户组所打开的文件信息
lsof -g 5555

21. 根据文件描述列出对应的文件信息
lsof -d description(like 2)

22. 根据文件描述范围列出文件信息
lsof -d 2-3
```
参考：
https://www.cnblogs.com/sparkbj/p/7161669.html