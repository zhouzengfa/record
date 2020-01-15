# redis面试
#### 一、 Redis与Memcached的区别与比较
1. Redis不仅仅支持简单的k/v类型的数据，同时还提供list，set，zset，hash等数据结构的存储。memcache支持简单的数据类型，String。
2. Redis支持数据的备份，即master-slave模式的数据备份。
3. Redis支持数据的持久化，可以将内存中的数据保持在磁盘中，重启的时候可以再次加载进行使用,而Memecache把数据全部存在内存之中
4. redis的速度比memcached快很多
5. Memcached是多线程，非阻塞IO复用的网络模型；Redis使用单线程的IO复用模型。

#### 二、redis有哪些数据淘汰策略
1. volatile-lru：从已设置过期时间的数据集（server.db[i].expires）中挑选最近最少使用的数据淘汰
1. volatile-ttl：从已设置过期时间的数据集（server.db[i].expires）中挑选将要过期的数据淘汰
1. volatile-random：从已设置过期时间的数据集（server.db[i].expires）中任意选择数据淘汰
1. allkeys-lru：从数据集（server.db[i].dict）中挑选最近最少使用的数据淘汰
1. allkeys-random：从数据集（server.db[i].dict）中任意选择数据淘汰
1. no-enviction（驱逐）：禁止驱逐数据

#### 三、Redis常见性能问题和解决方案:
1. Master最好不要做任何持久化工作，如RDB内存快照和AOF日志文件
2. 如果数据比较重要，某个Slave开启AOF备份数据，策略设置为每秒同步一次
3. 为了主从复制的速度和连接的稳定性，Master和Slave最好在同一个局域网内
4. 尽量避免在压力很大的主库上增加从库

#### 四、FailOver设计实现：

   Failover,通俗地说，一个master有N(N>=1)个slave,当master挂掉以后，能选出一个slave晋升成Master继续提供服务。Failover由失败判定和Leader选举两部分组成，Redis Cluster采用去中心化（Gossip）的设计，每个节点通过发送Ping（包括Gossip信息）/Pong心跳的方式来探测对方节点的存活，如果心跳超时则标记对方节点的状态为PFail，这个意思是说该节点认为对方节点可能失败了，有可能是网络闪断或者分区等其他原因导致通讯失败。例如节点A给节点B发Ping/Pong心跳超时，则A将B标记为PFAIL，强调一点，仅是在A看来B节点失败。要完全判定B失败，则需要一种协商的方式，需要集群中一半以上的Master节点认为B处于PFail状态，才会正式将节点B标记为Fail。那么问题来了，Master之间如何交换意见呢，或者说节点A如何知道其他Master也将B标记为PFfail了，并且能统计出是否有一半以上的Master认为B为PFail呢？前面提到Gossip，Gossip的主要作用就是信息交换，在A给C发Ping的时候，A将已知节点随机挑选三个节点添加到Ping包中发给C。既然是随机，经过多次Gossip以后，A会将处于PFail的B告诉给C。在节点C上，B节点有一个失败报告的链表，A告诉C，B可能失败，将A节点添加到B节点的失败报告链表中。经过集群中所有节点之间多次Gossip，一旦B的失败报告数量超过Master数量的一半以上，就立即标记B为Fail并广播给整个集群。那这样还会有一个问题，假设一天之内失败报告的数量超过Master的一半以上，同时报告的时间间隔又比较大，那么就会产生误判。所以得给失败报告加上一个有效期，在一定的时间窗口内，失败报告的数量超过Master的一半以上以后标记为Fail，这样才能避免误判。至此就把失败判定说完了

#### 五、RDB和AOF用哪个
RDB和AOF并不互斥，它俩可以**同时使用**。


- RDB的优点：载入时恢复数据快、文件体积小。
- RDB的缺点：会一定程度上丢失数据(因为系统一旦在定时持久化之前出现宕机现象，此前没有来得及写入磁盘的数据都将丢失。)
- AOF的优点：丢失数据少(默认配置只丢失一秒的数据)。
- AOF的缺点：恢复数据相对较慢，文件体积大

如果Redis服务器**同时开启**了RDB和AOF持久化，服务器会**优先使用AOF文件**来还原数据(因为AOF更新频率比RDB更新频率要高，还原的数据更完善)

#### 六、Redis分区有什么缺点
涉及多个key的操作通常不会被支持。例如你不能对两个集合求交集，因为他们可能被存储到不同的Redis实例（实际上这种情况也有办法，但是不能直接使用交集指令）。
同时操作多个key,则不能使用Redis事务.

#### 七、Redis的内存用完了会发生什么
如果达到设置的上限，Redis的写命令会返回错误信息（但是读命令还可以正常返回。）或者你可以将Redis当缓存来使用配置淘汰机制，当Redis达到内存上限时会冲刷掉旧的内容。

#### 八、pub/sub的缺点
在消费者下线的情况下，生产的消息会丢失

#### 九、redis如何实现延时队列
使用sortedset，拿时间戳作为score，消息内容作为key调用zadd来生产消息，消费者用zrangebyscore指令获取N秒之前的数据轮询进行处理