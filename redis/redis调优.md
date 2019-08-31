# redis调优

#### 一、内存
##### 1.设置最大可用内存

通过info memory可以查看内存的各项参数
* used_memory_rss：从操作系统上显示已经分配的内存总量
* mem_fragmentation_ratio： 内存碎片率
* used_memory_lua： Lua脚本引擎所使用的内存大小
* mem_allocator： 在编译时指定的Redis使用的内存分配器，可以是libc、jemalloc、tcmalloc。

在Redis配置文件中(Redis.conf)，通过设置“maxmemory”属性的值可以限制Redis最大使用的内存，修改后重启实例生效。 也可以使用客户端命令config set maxmemory 去修改值，这个命令是立即生效的，但会在重启后会失效，需要使用config rewrite命令去刷新配置文件。 若是启用了Redis快照功能，应该设置“maxmemory”值为系统可使用内存的45%，因为快照时需要一倍的内存来复制整个数据集，也就是说如果当前已使用45%，在快照期间会变成95%(45%+45%+5%)，其中5%是预留给其他的开销。 如果没开启快照功能，maxmemory最高能设置为系统可用内存的95%。

##### 2.设置回收策略
当内存使用达到设置的最大阀值时，需要选择一种key的回收策略，可在Redis.conf配置文件中修改“maxmemory-policy”属性值。 若是Redis数据集中的key都设置了过期时间，那么“volatile-ttl”策略是比较好的选择。但如果key在达到最大内存限制时没能够迅速过期，或者根本没有设置过期时间。那么设置为“allkeys-lru”值比较合适，它允许Redis从整个数据集中挑选最近最少使用的key进行删除(LRU淘汰算法)。Redis还提供了一些其他淘汰策略，如下：

* volatile-lru：使用LRU算法从已设置过期时间的数据集合中淘汰数据
* volatile-ttl：从已设置过期时间的数据集合中挑选即将过期的数据淘汰
* volatile-random：从已设置过期时间的数据集合中随机挑选数据淘汰
* allkeys-lru：使用LRU算法从所有数据集合中淘汰数据
* allkeys-random：从数据集合中任意选择数据淘汰
* no-enviction：禁止淘汰数据


#### 二、查看延迟时间
	redis-cli --latency -h 127.0.0.1 -p 6379
根据当前服务器不同的运行情况，延迟时间可能有所误差，通常1G网卡的延迟时间是200μs，Redis的响应延迟时间以毫秒为单位
延时问题分析：
* 使用slowlog查出引发延迟的慢命令
```
slowlog get 1
 1) 1) (integer) 12849
    2) (integer) 1495630160
    3) (integer) 61916
    4) 1) "KEYS"
       2) "20170524less*"
```
上面字段分别意思是：
1、日志的唯一标识符
2、被记录命令的执行时间点，以 UNIX 时间戳格式表示
3、查询执行时间，以微秒为单位
4、执行的命令，以数组的形式排列。完整命令是config get *
调整触发日志记录慢命令的阀值，比如5毫秒，可在Redis-cli工具中输入下面的命令配置：
`config set slowlog-log-slower-than 5000`

* 限制客户端连接数
因为`Redis`是单线程模型(只能使用单核)，来处理所有客户端的请求， 但由于客户端连接数的增长，处理请求的线程资源开始降低分配给单个客户端连接的处理时间，这时每个客户端需要花费更多的时间去等待`Redis`共享服务的响应。在`Redis-cli`工具中输入`info clients`可以查看到当前实例的所有客户端连接信息。

* 加强内存管理
 较少的内存会引起`Redis`延迟时间增加。如果`Redis`占用内存超出系统可用内存，操作系统会把Redis进程的一部分数据，从物理内存交换到硬盘上，内存交换会明显的增加延迟时间。可用`info memory`查看`redis`内存占用情况

#### 三、持久化设置

开启AOF时应当关闭AOF自动rewrite，并在crontab中启动在业务低峰时段进行的bgrewrite。 如果在一台机器上部署多个redis实例，则关闭RDB和AOF的自动保存（save "", auto-aof-rewrite-percentage 0），通过crontab定时调用保存：
```
m h * * * redis-cli -p <port> BGSAVE
m h */4 * * redis-cli -p <port> BGREWRITEAOF
```
持久化的部署规划上，如果为主从复制关系，建议主关闭持久化。

参考文档：
* https://www.cnblogs.com/chenpingzhao/p/6859041.html
* https://www.w3cschool.cn/redis_all_about/redis_all_about-q85x26wm.html