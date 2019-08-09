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
#### 8.GLBCXX重置
```
find / -name libstdc++.so.6*
cp /usr/local/gcc/lib64/libstdc++.so.6.0.25 /usr/lib64/libstdc++.so.6.0.25
mv /usr/lib64/libstdc++.so.6 /usr/lib64/libstdc++.so.6.old
ln -s /usr/lib64/libstdc++.so.6.0.25 /usr/lib64/libstdc++.so.6
strings /usr/lib64/libstdc++.so.6 | grep GLIBCXX
```
#### 9.设置环境变量
	1. vim /etc/profile
	2. 在最后加入
		export PATH=/usr/local/gcc/bin:$PATH
	3. source /etc/profile
	
#### 10. 验证
	g++ -v