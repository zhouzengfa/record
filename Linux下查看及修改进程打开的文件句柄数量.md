# Linux下查看及修改进程打开的文件句柄数量

* 查看Linux系统默认的最大文件句柄数，系统默认是1024
```
[root@localhost bin]# ulimit -n
1024
```

* 查看Linux系统某个进程打开的文件句柄数量
```
[root@localhost bin]# lsof -c 可执行文件 | wc -l
1942
```

* 修改Linux系统的最大文件句柄数限制的方

      1）ulimit -n 65535  

            针对当前session有效，用户退出或者系统重新后恢复默认值

      2）修改profile文件：在profile文件中添加：ulimit -n 65535 

           只对单个用户有效

      3）修改文件：/etc/security/limits.conf，在文件中添加：（立即生效-当前session中运行ulimit -a命令无法显示）
			* soft nofile 32768 #限制单个进程最大文件句柄数（到达此限制时系统报警）  
			* hard nofile 65536 #限制单个进程最大文件句柄数（到达此限制时系统报错）  

