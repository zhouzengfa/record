**文档迭代**

|  更新日期 | 操作人员  | 更新描述  |
| ------------ | ------------ | ------------ |
|  2018/10/15 |周增法    | 创建文档  |

# 部署镜像到k8s

以我们项目中的InterfaceServer为例，来说明如何把interface部署到k8s中，这里仅介绍通过yaml文件的方式部署容器，其它部署方式请自行了解。本文假设镜像仓库中已有可用的镜像。

内网k8s：http://172.16.2.242:8080/r/projects/1a7/kubernetes-dashboard:9090/#!/overview?namespace=default

## 一、编写K8s用的yaml文件
- **容器的部署**
下面是部署的相关配置，用于指定部署的相关信息，如：要启动的副本数量、标签、使用的镜像、环境变量等


	#部署，根据此部署信息会产生相应Pod
	apiVersion: extensions/v1beta1 #api版本
	kind: Deployment
	metadata: 
	  name: loho-interface		#此部署的名字，要唯一
	spec: 
	  replicas: 1 #此部署要启动的副本数量，运行过程中可修改
	  template: 
	    metadata: 
	      labels: #标签 area、node均为标签，此处可加多个标签。	Service可以根据此标签找到此部署对应的Pod，处理相应请求
	        area: test
	        node: interface
	    spec: 
	     containers:
	     - name: loho-interface #容器的名字
	       imagePullPolicy: Always #拉取镜像策略，Always总是从仓库拉取镜像；IfNotPresent 如果本地存在镜像就优先使用本地镜像
	       image: registry.loho.local:5000/loho/server/interfaceserver:2.5.1 #使用的镜像
	       env: #环境变量
	       - name: APOLLO_ENV
	         value: "dev"       
	       - name: APOLLO_CLUSTER
	         value: "default"       
	       - name: APOLLO_META
	         value: "http://172.16.1.152:8080"       
	       - name: ZK_ADDRESS
	         value: "115.159.98.76:2181,115.159.98.76:2182,115.159.98.76:2183"       
	       - name: ZK_NODE_PATH
	         value: "k8sTest"
	       - name: TRACE_LOG
	         value: "true"

- **服务的部署**
如果此应用需要对外提供服务，则需要部署如下服务配置，用于暴露端口和IP，否则外部无法访问我们的应用。


	#服务，用于对外服务
	apiVersion: v1 
	kind: Service 
	metadata: 
	  name: loho-interface
	  labels:
	    area: test
	    node: interface
	spec: 
	  type: LoadBalancer  #负载均衡
	  ports: 
	    - name: interface
	      port: 3671		#暴露给用户的端口
	      targetPort: 3671  #此Service接收的请求，会转发到此端口
	      protocol: TCP
	  selector: #此Service接收到的请求，转发到此标签标记的后端Pod上
	     area: test
	     node: interface
	  externalIPs: #在指定的node上创建此Service
	  - 172.16.2.242

	   
yaml脚本文件有严格的格式要求， 一定要注意缩进格式。

## 二、利用yaml文件把应用部署到k8s

- **导入yaml文件**
打开 http://172.16.2.242:8080/r/projects/1a7/kubernetes-dashboard:9090/#!/overview?namespace=default
按所示步骤导入yaml文件
![](http://seafile.kodgames.net/repo/3b166c5a-420c-430e-bd42-731e598e9596/raw/%E5%91%A8%E5%A2%9E%E6%B3%95/images/fluent-logging-import-yaml.png)
如果没有报错，表示部署成功

- **验证**
在k8s上生成pod和service如下：
deployment
![](http://seafile.kodgames.net/repo/3b166c5a-420c-430e-bd42-731e598e9596/raw/%E5%91%A8%E5%A2%9E%E6%B3%95/images/k8s_deployment_example.png)
Service
![](http://seafile.kodgames.net/repo/3b166c5a-420c-430e-bd42-731e598e9596/raw/%E5%91%A8%E5%A2%9E%E6%B3%95/images/k8s_service_example.png)

## 三、常见问题

- **导入yaml文件时报错**
一般为缩进的格式不正确，严格检查yaml文件的缩进格式

- **如何删除部署的容器**
![](http://seafile.kodgames.net/repo/3b166c5a-420c-430e-bd42-731e598e9596/raw/%E5%91%A8%E5%A2%9E%E6%B3%95/images/k8s_delete_deployment.png)

- **如何删除部署的Service**
与删除部署的容器类似

- **如何进入容器**
找到相关Pod，按如下操作
![](http://seafile.kodgames.net/repo/3b166c5a-420c-430e-bd42-731e598e9596/raw/%E5%91%A8%E5%A2%9E%E6%B3%95/images/k8s_enter_and_log.png)

- **容器未启动成功，如何查看错误**
执行命令：
kubectl describle pod pod名字
查看具体信息
此处需要安装kubectl，安装步骤请参考https://k8smeetup.github.io/docs/tasks/tools/install-kubectl/

- **更多调试细节，请参考官网**
https://k8smeetup.github.io/docs/tasks/debug-application-cluster/debug-pod-replication-controller/




