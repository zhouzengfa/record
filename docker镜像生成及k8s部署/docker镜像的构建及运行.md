**文档迭代**

|  更新日期 | 操作人员  | 更新描述  |
| ------------ | ------------ | ------------ |
|  2018/10/15 |周增法    | 创建文档  |

# docker镜像的构建及运行

以我们项目中的InterfaceServer为例，来说明如何把我们的应用构建成一个镜像、以及如何推送镜像到仓库、如何在docker上启动镜像等。

**大体流程为：**
      打包应用 ----> 编写Dockerfile ----> 构建镜像 ----> 测试 ----> 推送到仓库
	  
本文假设你已成功安装docker。

## 一、生成docker镜像
- **打包InterfaceServer**
利用Maven的Package功能，打包InterfaceServer，生成interface文件夹

-  **编写[Dockerfile](http://seafile.kodgames.net/lib/3b166c5a-420c-430e-bd42-731e598e9596/file/%E5%91%A8%E5%A2%9E%E6%B3%95/docker%E9%95%9C%E5%83%8F%E7%94%9F%E6%88%90%E5%8F%8Ak8s%E9%83%A8%E7%BD%B2/Script/Dockerfile "Dockerfile")**

		
	#基础镜像 每个镜像必须有一个基础镜像，可根据需要进行选择
	FROM registry.loho.local:5000/centos6:v1 
	
	#作者 无实际作用，可有可无
	MAINTAINER loho  
	
	#以env开头的命令均为环境变量，在此声明后，可在后续	docker容器或sh命令中直接使用.如：$APOLLO_ENV
	env APOLLO_ENV dev
	env APOLLO_CLUSTER	default
	env APOLLO_META http://172.16.1.152:8080
	env ZK_ADDRESS 	115.159.98.76:2181,115.159.98.76:2182,115.159.98.76:2183
	env ZK_NODE_PORT ""
	env TRACE_LOG true
	
	#把当前目录（与Dockerfile平级）下的文件夹添加到镜像的根目录下
	ADD interface /interface 
	ADD docker-entrypoint.sh /interface/bin/
	
	#添加文件的可执行权限
	run chmod +x /interface/bin/docker-entrypoint.sh 
	
	#镜像入口命令 启动容器后，从此开始执行。使用docker-entrypoint.sh入口文件的目的，是为了做一些服务器启动前的准备操作，如无需任何操作可省略此文件
	CMD ["/interface/bin/docker-entrypoint.sh"]

- **生成Docker镜像**
把写好的Dockerfile、[docker-entrypoint.sh](http://seafile.kodgames.net/lib/3b166c5a-420c-430e-bd42-731e598e9596/file/%E5%91%A8%E5%A2%9E%E6%B3%95/docker%E9%95%9C%E5%83%8F%E7%94%9F%E6%88%90%E5%8F%8Ak8s%E9%83%A8%E7%BD%B2/Script/docker-entrypoint.sh "docker-entrypoint.sh")与interface放在同一目录（如 /tmpdir)下，并执行 docker build 命令：

		
	docker build -t registry.loho.local:5000/loho/server/interfaceserver:2.5.1 -f Dockerfile .
	
等执行完成后，最后一行出现Successfully，表明构建成功。
注：
 1. registry.loho.local:5000 为仓库的地址，为后续推镜像到仓库做准备
 2. interfaceserver:2.5.1 为镜像的名字及版本，中间用：分割


## 二、运行Docker镜像
执行docker run命令，可以使镜像在容器中运行，例如：

	docker run -ti --rm registry.loho.local:5000/loho/server/interfaceserver:2.5.1

## 三、上传Docker镜像
如构建的镜像无问题，可用docker push 命令推送到仓库备用，例如：

	docker push registry.loho.local:5000/loho/server/interfaceserver:2.5.1

若上传失败，确认是否未配置http仓库，如未配置，编辑/etc/docker/daemon.json(没有自行添加),内容如下:
		
	{
 	"registry-mirrors":["https://registry.docker-cn.com"],
 	"insecure-registries":["registry.loho.local:5000"]
	}
然后重起docker

	service docker restart

## 四、常见问题
- **如何查容器ID**
执行命令：
docker ps
第一列即是

- **如何查看本地都有那些镜像**
执行命令：
docker images

- **如何删除本地镜像**
执行命令：
docker rmi 镜像ID

- **如何停止一个容器**
docker stop 容器ID或容器的名字

- ** 如何进入已启动的容器**
执行命令：

	docker exec -ti 容器ID /bin/bash

-  **如何在不启动镜像的情况下，进行容器**
有时需要查看启动脚本是否有问题，及镜像资源部署是否正确，可以用如下命令：

	docker run -ti --rm registry.loho.local:5000/loho/server/interfaceserver:2.5.1 /bin/bash
	
 先进入容器，但不启动镜像，等检查完成后，再在容器内手动执行镜像的入口脚本。如在本例中，可在/interface/bin下执行   
./entry-entrypoint.sh
启动镜像，以达到调试的目的。








