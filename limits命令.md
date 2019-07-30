# ulimit命令

#### 1.查看设置

`ulimit -a`

#### 2.设置core文件大小
```
1. vi /etc/security/limits.conf
2. 在文件末尾添加
	*               soft    core            unlimited
	*               hard    core            unlimited
	               
	说明：* 代表针对所有用户，core 是代表设置core文件，unlimited 表示无限制
3.保存重起
```