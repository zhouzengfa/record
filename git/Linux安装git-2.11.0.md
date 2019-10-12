# Linux安装git （git-2.11.0）

#### 1.下载
```
wget https://Github.com/Git/Git/archive/v2.11.0.tar.gz
```
#### 2.解压
	
	tar -zxvf git-2.11.0.tar.gz

#### 3.安装需要的软件

	yum install libcurl-devel zlib  zlib-devel perl-ExtUtils-MakeMaker package

#### 4.生成 configure
```
cd git-2.11.0
make configure
```

#### 5.配置并安装
```
./configure --prefix=/usr/local/git --with-iconv --with-curl --with-expat=/usr/local/lib
make -j 8 && make install
```

#### 6.配置环境
```
echo "export PATH=$PATH:/usr/local/git/bin" >> /etc/bashrc
source /etc/bashrc
```

#### 7.验证
	
	git --version