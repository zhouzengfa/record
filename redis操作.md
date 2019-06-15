##### 一、redis启动
	redis-server redis.conf
	
##### 二、关闭redis
	1.通过redis-cli连接服务器后执行shutdown命令
	2.可以使用shutdown命令关闭redis服务器外，还可以使用kill+进程号的方式关闭redis服务
	3.不要使用Kill 9方式关闭redis进程，这样redis不会进行持久化操作。
	
##### 三、redis允许局域网内其它服务器访问
	1.vi /etc/redis.conf 将bind 120.0.0.1 改为 bind 120.0.0.1 172.16.52.221（为自己的IP地址）
	2.设置 protected-node 为 no
	3.开放端口 或 关闭防火墙
		1.firewall-cmd --zone=public --add-port=80/tcp --permanent
		2.firewall-cmd --reload
	4.重起redis
	
##### 四、设置开机启动
##### 1.修改/etc/init.d/redis 文件
```shell
#!/bin/sh
# chkconfig: 2345 90 10  
# description: Start and Stop redis
# Simple Redis init.d script conceived to work on Linux systems
# as it does use of the /proc filesystem.

### BEGIN INIT INFO
# Provides:     redis_6379
# Default-Start:        2 3 4 5
# Default-Stop:         0 1 6
# Short-Description:    Redis data structure server
# Description:          Redis data structure server. See https://redis.io
### END INIT INFO

REDISPORT=6379
EXEC=redis-server
CLIEXEC=redis-cli

PIDFILE=/var/run/redis_${REDISPORT}.pid
CONF="/etc/redis.conf"

case "$1" in
    start)
        if [ -f $PIDFILE ]
        then
                echo "$PIDFILE exists, process is already running or crashed"
        else
                echo "Starting Redis server..."
                $EXEC $CONF
        fi
        ;;
    stop)
        if [ ! -f $PIDFILE ]
        then
                echo "$PIDFILE does not exist, process is not running"
        else
                PID=$(cat $PIDFILE)
                echo "Stopping ..."
                $CLIEXEC -p $REDISPORT shutdown
                while [ -x /proc/${PID} ]
                do
                    echo "Waiting for Redis to shutdown ..."
                    sleep 1
                done
                echo "Redis stopped"
        fi
        ;;
    *)
        echo "Please use start or stop as first argument"
        ;;
esac
```	
###### 2.添加redis服务
	chkconfig --add redis			
###### 3.设为开机启动
	chkconfig redis on			
###### 4.打开redis命令
	service redis start			
###### 5.关闭redis命令
	service redis stop