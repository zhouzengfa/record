# Dockerfile for InterfaceServer
# Build with:
# docker build -t registry.loho.local:5000/loho/server/interfaceserver:2.5.1 -f Dockerfile ../

FROM registry.loho.local:5000/centos6:v1
 #作者 无实际作用，可有可无
MAINTAINER loho  

#以env开头的命令均为环境变量，在此声明后，可在后续docker容器或sh命令中直接使用.如：$APOLLO_ENV
env APOLLO_ENV dev
env APOLLO_CLUSTER	default
env APOLLO_META http://172.16.1.152:8080
env ZK_ADDRESS 115.159.98.76:2181,115.159.98.76:2182,115.159.98.76:2183
env ZK_NODE_PORT ""
env TRACE_LOG true

 #把当前目录（与Dockerfile平级）下的文件夹添加到镜像的根目录下
ADD interface /interface 
ADD docker-entrypoint.sh /interface/bin/

#添加文件的可执行权限
run chmod +x /interface/bin/docker-entrypoint.sh 

 #镜像入口命令 启动容器后，从此开始执行
CMD ["/interface/bin/docker-entrypoint.sh"]

