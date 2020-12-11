# cgdb 安装

### 一、依赖安装

```shell
yum install -y flex texinfo
```

### 二、cgdb安装

```shelll
git clone git://github.com/cgdb/cgdb.git
cd cgdb
./autogen.sh
./configure --prefix=/usr/local
make
sudo make install
```

### 三、使用

```
1. 附加进程
 cgdb -p pid

2. 直接调试
cgdb 进程
```

### 四、快捷键

```
1.esc键全焦点进入到vi窗口，再按i键回到gdb窗口
2.“空格“键 加断点和取消断点
3.o键打开文件
4.- 缩小代码窗口
5.+ 增大代码窗口
6.F5 发送run命令到gdb
7.F6 发送continue命令到gdb
8.F7 发送finish命令到gdb
9.F8 发送next命令到gdb
10.F10 发送step命令到gdb
```



### 参考

1. [cgdb官网](http://cgdb.github.io/)
2.  [CGDB中文手册](https://www.bookstack.cn/read/cgdb-manual-in-chinese/README.md)