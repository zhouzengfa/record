# centos7配置虚拟机静态ip

说明：使用的是虚拟机Nat模式

##### 1. 查看虚拟机网关
编辑->虚拟网络编辑器->选择VMnet8->NET设置->网关IP

##### 2. 修改配置
```
#修改
BOOTPROTO=static #这里讲dhcp换成ststic
ONBOOT=yes #将no换成yes
#新增
IPADDR=192.168.169.128 #静态IP
GATEWAY=192.168.169.2 #默认网关
NETMASK=255.255.255.0
DNS1=192.168.169.2 #默认网关
DNS2=114.114.114.114
```

##### 3. 重起网络
	systemctl restart network
