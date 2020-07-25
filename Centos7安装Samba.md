#### 1.安装
	yum install samba

#### 2.查看安装情况
 	rpm -qa | grep samba

 	输出：
		samba-client-libs-4.8.3-4.el7.x86_64
		samba-4.8.3-4.el7.x86_64
		samba-common-libs-4.8.3-4.el7.x86_64
		samba-common-tools-4.8.3-4.el7.x86_64
		samba-common-4.8.3-4.el7.noarch
		samba-libs-4.8.3-4.el7.x86_64
		
#### 3.创建共享目录
		mkdir /home/dev
	
#### 4.修改权限
		chmod 777 /home/dev
		
#### 5.在/etc/samba/smb.conf未尾加入 
```
[Share]
         comment = Shared Folder with username and password
         path = /home/dev
         public = yes
         writable = yes
         valid users = root
         create mask = 0777
         directory mask = 0777
         force user = root
         force group = root
         available = yes
         browseable = yes
         force directory mode = 0777
         force create mode = 0777
```
#### 6.查看配置格式是否正确
	testparm
	        
#### 7.添加samba用户
	smbpasswd -a root
	输入两次密码 root
	
#### 8.启动smb服务器
	systemctl start smb
	
#### 9.设置开机启动
	systemctl enable smb
	
#### 10.关闭防火墙
	systemctl stop firewalld.service
	
#### 11.在windows下登陆
	1.在cmd框内输出 \\linux ip
	2.在弹出的框内输入用户名和密码 root

**可能出现的问题：**
1. 输入正确的用户名密码，提示用户名或密码错误

		尝试运行-secpol.msc-本地策略-安全选项-网络安全: LAN 管理器身份验证级别-发送仅 NTLMv2 响应
2. 若提示权限限制，查看SELinux配置
```
setsebool -P samba_export_all_rw on
```
备注：	selinux相关操作
	1. 查看文件上下文
	```
	ls -Z
	```
	2. 设置文件上下文类型
	```
	chcon -t home_root_t filename
	```