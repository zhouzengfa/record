# CentOS 7编译安装Python 3
#### 一、安装所需工具
	yum install yum-utils

#### 二、下载python3版本
	wget https://www.python.org/ftp/python/3.5.0/

#### 三、 按如下步骤安装python3。默认的安装路径为/usr/local。如果需要更改到其它目录，指定编译参数–prefix=/alternative/path

```shell
xz -d Python-3.5.0.tar.xz 
tar xf Python-3.5.0.tgr
cd Python-3.5.0
./configure
make
make install
```
#### 四、验证
	python3 --version

#### 五、执行以下命令，安装pip
```shell
curl -O https://bootstrap.pypa.io/get-pip.py
python3.5 get-pip.py
``` 