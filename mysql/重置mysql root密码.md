# 重置mysql root密码

##### 1.关闭mysql服务器
	service mysqld stop

##### 2.进入安全模式
	mysqld_safe --user=mysql --skip-grant-tables --skip-networking &
##### 3.设置root密码
	UPDATE user SET Password=PASSWORD(’密码’) where User=’root’;
##### 4.刷新权限
	FLUSH PRIVILEGES;
	quit; 
##### 5.重起mysql
	service mysql restart
##### 6.使用密码登陆
	mysql -uroot -p密码
