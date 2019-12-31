**文档迭代**

|  更新日期 | 操作人员  | 更新描述  |
| ------------ | ------------ | ------------ |
|  2018/11/12 |周增法    | 创建文档  |

# HAProxy简单配置

以下为在Centos7上的操作步骤：

- ### HAProxy安装
 - ##### 下载包
```
wget https://src.fedoraproject.org/repo/pkgs/haproxy/haproxy-1.8.7.tar.gz/sha512/f3bbd138d389fcd55d9db2837f6261face3399a95493b3eaf6b33e19bc404d3564abbc42698573a5f94c22ea3d1e41cd604c1d879a73dd83740cf325b867231c/haproxy-1.8.7.tar.gz
```
 - ##### 解压、编译并安装
 ```
 tar xzvf haproxy-1.8.7.tar.gz
 cd haproxy-1.7.8
make TARGET=linux2628 PREFIX=/usr/local/haproxy
make install PREFIX=/usr/local/haproxy
cp /usr/local/haproxy/sbin/haproxy /usr/sbin/
cp ./examples/haproxy.init /etc/init.d/haproxy 
 ```

- ### 编辑配置文件`/etc/haproxy/haproxy.conf`     
若没此文件，则创建
```
#---------------------------------------------------------------------
# Global settings
#---------------------------------------------------------------------
global
    log         127.0.0.1 local2
    chroot      /var/lib/haproxy
    pidfile     /var/run/haproxy.pid
    maxconn     4000
    user        root
    group       root
    daemon
    # turn on stats unix socket
    stats socket /var/lib/haproxy/stats
#---------------------------------------------------------------------
# common defaults that all the 'listen' and 'backend' sections will
# use if not designated in their block
#---------------------------------------------------------------------
defaults
    mode                    tcp
    log                     global
    option                  tcplog
    option                  dontlognull
    option                  redispatch
    retries                 3
    timeout queue           1m
    timeout connect         10s
    timeout client          1m
    timeout server          1m
    maxconn                 3000
#frontend front_end
#    bind *:5000 transparent
#    mode tcp
#    default_backend backend_transfer
#
#backend backend_transfer
#   mode tcp
#   #source 0.0.0.0 usesrc clientip
#   server transfer 127.0.0.1:2066 send-proxy
#
#frontend frontend_transfer
#   mode tcp
#   bind 127.0.0.1:2066 accept-proxy
#   default_backend backend_loho
#
#backend backend_loho
#   mode tcp
#   #source 0.0.0.0 usesrc clientip
#   server loho 172.16.2.244:3671 send-proxy
#   #server loho 172.16.2.109:3671 send-proxy
#---------------------------------------------------------------------
# main frontend which proxys to the backends
#---------------------------------------------------------------------
listen  main
    bind *:5000
    mode tcp
    balance    source
    #source 0.0.0.0 usesrc clientip
    #server  app1 172.16.2.109:3671 check send-proxy
    server  app1 172.16.2.244:31305 check send-proxy
```

- ### 开启日志

 - ##### 修改haproxy配置文件
vi /etc/haproxy/haproxy.cfg 可以看到如下行，把这个开启
```
log 127.0.0.1 local2
```
没有指定端口，默认为udp 514

  - ##### 修改rsyslog配置文件
  ```
vi /etc/rsyslog.conf
#启用在udp 514端口接收日志消息
$ModLoad imudp
$UDPServerRun 514
#在rules（规则）节中添加如下信息
local2.* /var/log/haproxy.log
#表示将发往facility local2的消息写入haproxy.log文件中，"local2.* "前面的local2表示facility,预定义的。*表示所有等级的消息
```

 - ##### 重启rsyslog服务
 ```
systemctl restart rsyslog
```
- ### 起动haproxy
 ```
service haproxy start
```

配置完成，尝试连接haproxy所在的主机+Port(5000)，验证是否能转发到172.16.2.244:31305。

参考文档：
https://www.jianshu.com/p/edf2c8c7d83f
