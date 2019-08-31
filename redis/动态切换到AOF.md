# redis 持久化配置 无缝从rdb切换到aof 安全保留数据
### 问题

redis默认持久化配置rdb，但是如果贸然切换配置到aof方式，重启会导致数据丢失

### 根本原因

* `rdb`方式默认将数据持久化存储到`dump.rdb`文件下
* `aof`方式默认将数据写操作记录到`appendonly.aof`文件下
* 如果同时开启2种方式，重启会默认加载`aof`方式
* `redis`默认只开启`rdb`
* 综上，如果你是默认`rdb`方式，然后贸然切换到aof，重启后会读取`aof`文件，但是这个时候`aof`文件是空的，则会导致`redis`被清空

### 解决方法

原理：在`redis`控制台动态配置打开`aof`方式，在`shutdown`安全退出后，自动记录了当前所有记录到`aof`文件，再修改`redis`文件配置打开`aof`方式，启动`redis`时会自动加载之前安全退出保存的aof数据
1.进入`redis`

	redis-cli

2.redis中动态修改配置并退出
```
127.0.0.1:6379> save  # 收到触发rdb存储数据
OK
127.0.0.1:6379> CONFIG SET appendonly yes  # 动态配置
OK
127.0.0.1:6379> save
OK
127.0.0.1:6379> shutdown save # 安全退出并存储数据
not connected> 
```

3.修改`redis`配置，打开`aof`
```
vim redis.conf
appendonly no #aof方式默认关闭
```

4.启动redis

	service redis start


