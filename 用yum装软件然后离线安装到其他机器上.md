# centos7用yum只下载不安装软件及其依赖，然后离线安装到其他机器上
##### 1.下载软件
找一台`全新的centos7`(注意要是全新的，否则可能依赖库不会被下载) 可以是虚拟机，指定如下参数
```
--downloadonly#只下载
--downloaddir=temp#rpm的下载保存地址
```
用命令：
```
yum install --downloadonly --downloaddir=vim vim
```
在vim下看到下载的软件及其依赖，然后放到新机器上

##### 2.安装到新机器
把下载下来的安装包入到新机器上，执行如下命令安装
```
rpm -ivh *.rpm
```