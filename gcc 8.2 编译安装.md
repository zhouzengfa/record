#### 1.下载安装包
	wget http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-8.2.0/gcc-8.2.0.tar.gz
	
#### 2.解压
	tar -zxv gcc-8.2.0.tar.gz 

#### 3.进入解压后目录
	cd gcc-8.2.0/

#### 4.下载依赖包
	./contrib/download_prerequisites 
	
#### 5.配置
	./configure --prefix=/usr/local/gcc --enable-bootstrap --enable-checking=release --enable-languages=c,c++ --disable-multilib
	
#### 6.编译
	make -j 8

#### 7.安装
	make install

#### 8.设置环境变量
	1. vim /etc/profile
	2. 在最后加入
		export PATH=/usr/local/gcc-8.2.0/bin:$PATH
	3. source /etc/profile
	
#### 9. 验证
	g++ -v