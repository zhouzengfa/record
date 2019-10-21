# CentOS7.0使用yum安装mysql 5.6
###### 1.下载mysql的repo源
	wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm

###### 2.安装mysql-community-release-el7-5.noarch.rpm包
	rpm -ivh mysql-community-release-el7-5.noarch.rpm

###### 3.安装mysql
	yum -y install mysql mysql-community-server

###### 4.设置开机启动
	systemctl enable mysqld
###### 5.启动mysql服务器进程
	systemctl start mysqld
###### 6.配置msyql（设置密码等)
	mysql_secure_installation
	
```shell
NOTE: RUNNING ALL PARTS OF THIS SCRIPT IS RECOMMENDED FOR ALL MySQL
      SERVERS IN PRODUCTION USE!  PLEASE READ EACH STEP CAREFULLY!

In order to log into MySQL to secure it, we'll need the current
password for the root user.  If you've just installed MySQL, and
you haven't set the root password yet, the password will be blank,
so you should just press enter here.

Enter current password for root (enter for none): 
OK, successfully used password, moving on...

Setting the root password ensures that nobody can log into the MySQL
root user without the proper authorisation.

Set root password? [Y/n] y                  [设置root用户密码]
New password: 
Re-enter new password: 
Password updated successfully!
Reloading privilege tables..
 ... Success!


By default, a MySQL installation has an anonymous user, allowing anyone
to log into MySQL without having to have a user account created for
them.  This is intended only for testing, and to make the installation
go a bit smoother.  You should remove them before moving into a
production environment.

Remove anonymous users? [Y/n] y                 [删除匿名用户]
 ... Success!

Normally, root should only be allowed to connect from 'localhost'.  This
ensures that someone cannot guess at the root password from the network.

Disallow root login remotely? [Y/n] y       [禁止root远程登录]
 ... Success!

By default, MySQL comes with a database named 'test' that anyone can
access.  This is also intended only for testing, and should be removed
before moving into a production environment.

Remove test database and access to it? [Y/n] y          [删除test数据库]
 - Dropping test database...
ERROR 1008 (HY000) at line 1: Can't drop database 'test'; database doesn't exist
 ... Failed!  Not critical, keep moving...
 - Removing privileges on test database...
 ... Success!

Reloading the privilege tables will ensure that all changes made so far
will take effect immediately.

Reload privilege tables now? [Y/n] y            [刷新权限]
 ... Success!




All done!  If you've completed all of the above steps, your MySQL
installation should now be secure.

Thanks for using MySQL!


Cleaning up...
```

##### 7.进入mysql
	mysql -uroot -proot
