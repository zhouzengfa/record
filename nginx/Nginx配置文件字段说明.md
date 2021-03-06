# Nginx配置文件字段说明

nginx.conf 配置
```
########### 每个指令必须有分号结束。#################
#user administrator administrators;  #配置用户或者组，默认为nobody nobody。
#worker_processes 2;  #允许生成的进程数，默认为1
#pid /nginx/pid/nginx.pid;   #指定nginx进程运行文件存放地址
error_log log/error.log debug;  #制定日志路径，级别。这个设置可以放入全局块，http块，server块，级别以此为：debug|info|notice|warn|error|crit|alert|emerg
events {
    accept_mutex on;   #设置网路连接序列化，防止惊群现象发生，默认为on
    multi_accept on;  #设置一个进程是否同时接受多个网络连接，默认为off
    #use epoll;      #事件驱动模型，select|poll|kqueue|epoll|resig|/dev/poll|eventport
    worker_connections  1024;    #最大连接数，默认为512
}
http {
    include       mime.types;   #文件扩展名与文件类型映射表
    default_type  application/octet-stream; #默认文件类型，默认为text/plain
    #access_log off; #取消服务日志    
    log_format myFormat '$remote_addr–$remote_user [$time_local] $request $status $body_bytes_sent $http_referer $http_user_agent $http_x_forwarded_for'; #自定义格式
    access_log log/access.log myFormat;  #combined为日志格式的默认值
    sendfile on;   #允许sendfile方式传输文件，默认为off，可以在http块，server块，location块。
    sendfile_max_chunk 100k;  #每个进程每次调用传输数量不能大于设定的值，默认为0，即不设上限。
    keepalive_timeout 65;  #连接超时时间，默认为75s，可以在http，server，location块。
    include /usr/local/nginx/conf.d/*.conf; # 包含配置的其它服务器
    upstream mysvr {   
      server 127.0.0.1:7878;
      server 192.168.10.121:3333 backup;  #热备
    }
    error_page 404 https://www.baidu.com; #错误页
    server {
        keepalive_requests 120; #单连接请求上限次数。
        listen       4545;   #监听端口
        server_name  127.0.0.1;   #监听地址       
        location  ~*^.+$ {       #请求的url过滤，正则匹配，~为区分大小写，~*为不区分大小写。
           #root path;  #根目录
           #index vv.txt;  #设置默认页
           proxy_pass  http://mysvr;  #请求转向mysvr 定义的服务器列表
           deny 127.0.0.1;  #拒绝的ip
           allow 172.18.5.54; #允许的ip           
        } 
    }
}
```
在/usr/local/nginx/conf.d目录下增加任意名字，但后辍必须为.conf的文件
```
server {
    listen       8011;
    server_name  test.cn;
    root /usr/local/nginx/www;
    index index.php;

    location ~ \.php?.*$ {
        try_files $uri /index.php =404;
        fastcgi_index  index.php;
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}
```
几个常见配置项：
* 1.$remote_addr 与 $http_x_forwarded_for 用以记录客户端的ip地址；
* 2.$remote_user ：用来记录客户端用户名称；
* 3.$time_local ： 用来记录访问时间与时区；
* 4.$request ： 用来记录请求的url与http协议；
* 5.$status ： 用来记录请求状态；成功是200；
* 6.$body_bytes_s ent ：记录发送给客户端文件主体内容大小；
* 7.$http_referer ：用来记录从那个页面链接访问过来的；
* 8.$http_user_agent ：记录客户端浏览器的相关信息；

参考：
https://www.runoob.com/w3cnote/nginx-setup-intro.html