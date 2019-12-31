**文档迭代**

|  更新日期 | 操作人员  | 更新描述  |
| ------------ | ------------ | ------------ |
|  2018/10/17 |周增法    | 创建文档  |

# 如何创建Service

以我们的InterfaceServer为例。

- **定义 Service 文件**

```
apiVersion: v1 
kind: Service 
metadata: 
  name: loho-interface
  labels:
    name: test    
spec: 
  type: LoadBalancer
  ports: 
    - name: interface
      port: 3671         #对外端口
      targetPort: 3671   #内部端口（应用暴露的端口），Service会把接收到的流量转发到此端口上
      protocol: TCP
  selector:              #通过此选择器，指向带有相应标签的Pod
     name: test
 #externalIPs:
 #- 172.16.1.183
```
上述配置将创建一个名称为 “ loho-interface” 的 Service 对象，它会将请求转发到使用 TCP 端口 3671，并且具有标签 "name=test" 的 Pod 上。 这个 Service 将被指派一个 IP 地址（通常称为 “Cluster IP”）。

- **定义应用**

```
apiVersion: extensions/v1beta1
kind: Deployment
metadata: 
  name: loho-interface
spec: 
  replicas: 1
  template: 
    metadata: 
      labels: 
        name: test  #对应上面的Service selector
    spec: 
     containers:
     - name: loho-interface
       imagePullPolicy: Always
       image: registry.loho.local:5000/loho/server/interfaceserver:2.5.1

```
参考地址：https://kubernetes.io/docs/tasks/debug-application-cluster/debug-service/

