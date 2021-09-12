## tcmalloc 的使用方法

以ubuntu为例

### 一、 tcmalloc的安装

##### 1. 安装 

```shell
apt-get install google-preftools
ln -s /usr/lib/libtcmalloc.so /usr/lib/x86_64-linux-gnu/libtcmalloc.so.4
```

### 二、使用

有两种使用方式 

##### 1. 当作编译参数使用

```shell
# 在CMakeList.txt中加入
link_libraries(tcmalloc)
```

##### 2. 对编译好的程序直接他用 

```shell
LD_PRELOAD="/usr/lib/libtcmalloc.so" ./test
```

### 三、使用tcmalloc做内存泄漏检测

##### 1. 启动程序 

```shell
LD_PRELOAD="/usr/lib/libtcmalloc.so" HEAPCHECK=normal ./test
```

##### 2. 生成易读文件

```shell
google-pprof ./tcmalloc_test "/tmp/tcmalloc_test.14180._main_-end.heap" --inuse_objects --lines --heapcheck  --edgefraction=1e-10 --nodefraction=1e-10 --text
```



###### 参考

1.https://www.jianshu.com/p/c6096adca7c0