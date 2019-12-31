# 如何创建Deployment

Deployment 为 Pod 和 ReplicaSet 提供了一个声明式定义(declarative)方法，用来替代以前的ReplicationController 来方便的管理应用。典型的应用场景包括：

- 定义Deployment来创建Pod和ReplicaSet
- 滚动升级和回滚应用
- 扩容和缩容
- 暂停和继续Deployment

#### 一、以interface为例，脚本interface.yaml实现如下：

```
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: interface
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: interface
    spec:
     #serviceAccountName: serviceaccount
     containers:
     - name: loho-interface
       imagePullPolicy: Always
       image: registry.loho.local/loho/server/interface:2.5.6
       ports:
       - containerPort: 80
       env:
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
```
#### 二、更新
```
kubectl set image deployment/interface loho-interface=registry.loho.local/loho/server/interface:2.5.7
```

#### 三、回滚
```
kubectl rollout undo deployment/interface
```

参考文档：
https://jimmysong.io/kubernetes-handbook/concepts/deployment.html