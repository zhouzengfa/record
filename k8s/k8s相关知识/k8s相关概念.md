**文档迭代**

|  更新日期 | 操作人员  | 更新描述  |
| ------------ | ------------ | ------------ |
|  2018/10/17 |周增法    | 创建文档  |

# Kubernetes 概念
- **Pod**
   - Pods 是 Kubernetes 平台上原子级别的单元。当我们在 Kubernetes 上创建一个部署时，该部署将在其中创建包含容器的 Pod (而不是直接创建容器)。每个 Pod 都绑定到它被调度的节点，并且始终在那里，直到终止或删除。
   - 一个Pod 内可以部署一个或多个应用容器。
   - Pod 中的容器共享 IP 地址和端口空间，始终位于同一位置并且统一调度，并在相同的节点上运行，共享上下文环境。 

![](http://seafile.kodgames.net/repo/3b166c5a-420c-430e-bd42-731e598e9596/raw/%E5%91%A8%E5%A2%9E%E6%B3%95/images/k8s_concept_pods.png)

- **Node**
  - Node 是 Kubernetes 的工作机器，可以是虚拟机或物理机。
  - 一个节点上可以有多个 Pod, Kubernetes master 会自动处理调度集群各个节点上的 Pod。 Master 在自动调度时，会考虑每个 Node 上的可用资源。
  - Pod 总是运行在 Node上。

![](http://seafile.kodgames.net/repo/3b166c5a-420c-430e-bd42-731e598e9596/raw/%E5%91%A8%E5%A2%9E%E6%B3%95/images/k8s_concept_nodes.png)
 
     1. Kubelet 是负责 Kubernetes Master 和 所有节点之间通信的进程，它管理机器上运行的 Pod 和容器。
     2. 容器运行时(例如 Dockert) 负责从镜像仓库中拉取容器镜像，解包容器并运行应用程序。


- **Service**
![](http://seafile.kodgames.net/repo/3b166c5a-420c-430e-bd42-731e598e9596/raw/%E5%91%A8%E5%A2%9E%E6%B3%95/images/k8s_concept_service.jpg)
  - 由于Pod的IP会变化，提供某些功能的POD如果IP发生变化，会导致其他Pod无法发现这些功能，因此 引入了Service的功能。

  - Service是一组逻辑Pod的抽象，定义了一个访问这些Pod的策略，这些Service 通常通过Label Selector指向这些Pod。
  
   如何创建[Service](http://seafile.kodgames.net/lib/3b166c5a-420c-430e-bd42-731e598e9596/file/%E5%91%A8%E5%A2%9E%E6%B3%95/k8s%E7%9B%B8%E5%85%B3%E7%9F%A5%E8%AF%86/%E5%A6%82%E4%BD%95%E5%88%9B%E5%BB%BAService.md "Service")

- **Deployment**
主要用于部署无状态的应用，与StatefulSet相对应。
名词解释请参考：https://www.kubernetes.org.cn/deployment


- **StatefulSet**
主要用部署有状态的应用，与Deployment相对应
名词解释请参考：https://www.kubernetes.org.cn/statefulset
用例请参考[Kafka部署](http://seafile.kodgames.net/#common/lib/3b166c5a-420c-430e-bd42-731e598e9596/%E5%91%A8%E5%A2%9E%E6%B3%95/k8s%E9%83%A8%E7%BD%B2kafka%E9%9B%86%E7%BE%A4 "Kafka部署")

- **Secrets**
Secret解决了密码、token、密钥等敏感数据的配置问题，而不需要把这些敏感数据暴露到镜像或者Pod Spec中。
[示例](http://seafile.kodgames.net/lib/3b166c5a-420c-430e-bd42-731e598e9596/file/%E5%91%A8%E5%A2%9E%E6%B3%95/k8s%E7%9B%B8%E5%85%B3%E7%9F%A5%E8%AF%86/%E5%A6%82%E4%BD%95%E4%BD%BF%E7%94%A8Secret.md "示例")

- **ConfigMap**
ConfigMap用于保存配置数据的键值对，可以用来保存单个属性，也可以用来保存配置文件。ConfigMap跟secret很类似，但它可以更方便地处理不包含敏感信息的字符串。
参考用例：https://www.kubernetes.org.cn/configmap

- **Persistent Volumes**
  - PersistentVolume（PV）是集群中已由管理员配置的一段网络存储。 集群中的资源就像一个节点是一个集群资源。 PV是诸如卷之类的卷插件，但是具有独立于使用PV的任何单个pod的[生命周期。](https://jimmysong.io/kubernetes-handbook/concepts/persistent-volume.html "生命周期。")
  - PersistentVolumeClaim（PVC）是用户存储的请求。
  - StorageClass为管理员提供了一种描述他们提供的存储（PV）的“类”的方法。
参考用例：
https://kubernetes.io/zh/docs/tutorials/stateful-application/mysql-wordpress-persistent-volume/#%E5%88%9B%E5%BB%BA-mysql-%E5%AF%86%E7%A0%81-secret

- **QoS（服务质量等级）**
  - 该配置的作用是为了给资源调度提供策略支持，调度算法根据不同的服务质量等级可以确定将 pod 调度到哪些节点上。
  - 当Node资源不足时，会根据此策略对Pod进行驱逐。
  
  参考地址：https://jimmysong.io/kubernetes-handbook/concepts/qos.html

