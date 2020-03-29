# php-fpm + mysql配置

##### 1.安装mysqli
```
 yum install -y php-mysql
```

##### 2.修改php.ini
打开 /etc/php.ini,修改
```
extension_dir="/usr/lib/php/modules/"
```

##### 3.重起php-fpm
```
systemctl restart php-fpm
```
