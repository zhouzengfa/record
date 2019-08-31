# Redis 恢复

* 如果只使用了RDB，则首先将redis-server停掉，删除dump.rdb，最后将备份的dump.rdb文件拷贝回data目录，然后启动redis-server。

* 如果是RDB+AOF的持久化，只需要将aof文件放入data目录，启动redis-server，查看是否恢复，如无法恢复则应该将aof关闭后重启，redis就会从rdb进行恢复了，随后调用命令BGREWRITEAOF进行AOF文件写入，在info的aof_rewrite_in_progress为0后一个新的aof文件就生成了，此时再将配置文件的aof打开，再次重启redis-server就可以恢复了。

* 注意先不要将dump.rdb放入data目录，否则会因为aof文件万一不可用，则rdb也不会被恢复进内存，此时如果有新的请求进来后则原先的rdb文件被重写。

* 如果只配置了AOF，重启时加载AOF文件恢复数据。


参考：
https://www.w3cschool.cn/redis_all_about/redis_all_about-lpxq26xb.html