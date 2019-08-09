# 使用yum安装redis
#### 备份你的原镜像文件，保证出错后可以恢复：
	mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup

#### 下载新的CentOS-Base.repo 到`/etc/yum.repos.d/`
	wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
#### 安装redis
	yum install redis
#### 设置后台运行
	vi /etc/redis.conf
	修改 daemonize no为daemonize yes

#### 启动redis
	systemctl start redis.service
#### 设置redis开机启动
	systemctl enable redis.service
#### 高级设置
##### 设置redis密码
```
打开文件/etc/redis.conf，找到其中的# requirepass foobared，去掉前面的#，并把foobared改成你的密码。
redis.conf文件默认在/etc目录下，你可以更改它的位置和名字，更改后，注意在文件/usr/lib/systemd/system/redis.service中，把ExecStart=/usr/bin/redis-server /etc/redis/6379.conf --daemonize no中的redis.conf的路径改成的新的路径。
```