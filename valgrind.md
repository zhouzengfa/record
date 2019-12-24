# valgrind 用法
##### 1. memcheck 内存检测 
```
valgrind --tool=memcheck --leak-check=full --log-file=valgrind.log ./LoginServer
```

###### 2. callgrind 性能分析 
```
valgrind --tool=callgrind --separate-threads=yes ./exproxy
```
--separate-threads=yes 表示为每个线程生成一个分析文件。让程序正常退出，然后用 [KCacheGrind](https://sourceforge.net/projects/qcachegrindwin/ "下载地址") 查看，分析性能。

