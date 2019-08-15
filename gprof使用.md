## gprof 的使用方法
### 一、 用gprof对程序进行分析主要分以下几个步骤：
##### 1. 用编译器对程序进行编译，加上-pg参数
	注意，编译和链接都要加上
##### 2. 运行编译后的程序
    和运行普通程序一样，只是运行后会产生一个gmon.out文件
##### 3. 安装gprof2dot
	pip install gprof2dot

##### 4. 安装graphviz
	yum install graphviz

##### 5.产生调用关系图
	gprof 可执行文件| gprof2dot -n0 -e0 -s | dot -Tsvg -o output.svg

##### 6.用网页打开。output.svg
###### 参考
1.https://github.com/jrfonseca/gprof2dot