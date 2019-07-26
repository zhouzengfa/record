
#### 一、查看防火墙状态
	systemctl status firewalld.service	
#### 二、开启防火墙
	systemctl status firewalld.service	
#### 三、关闭防火墙
	systemctl stop firewalld.service	
#### 四.设置开机启动
	systemctl enable firewalld	
#### 五.停止并禁用开机启动
	sytemctl disable firewalld	
#### 六.重启防火墙
	firewall-cmd --reload	
#### 七、开启端口
	1.增加端口
		firewall-cmd --zone=public --add-port=80/tcp --permanent
		
		命令含义：
			–zone #作用域
			–add-port=80/tcp #添加端口，格式为：端口/通讯协议
			–permanent #永久生效，没有此参数重启后失效
	2.重启防火墙
		firewall-cmd --reload	 		
#### 八、查看已经开放的端口
	firewall-cmd --list-ports	
	 		
#### 参考网址：
https://www.cnblogs.com/eaglezb/p/6073739.html