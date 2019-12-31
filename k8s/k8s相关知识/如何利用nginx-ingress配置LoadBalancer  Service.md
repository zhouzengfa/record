**文档迭代**

|  更新日期 | 操作人员  | 更新描述  |
| ------------ | ------------ | ------------ |
|  2018/11/24 |周增法    | 创建文档  |

# 如何利用nginx-ingress配置LoadBalancer Service

因为Rancher在裸机上架设的集群没有四层负载均衡器，k8s不能自动为LoadBalancer类型的Service分配负载均衡器，所以需要我们另外做配置，下面是利用nginx-ingress配置LoadBalancer类型Service的方法。

下面以jenkins为例，演示创建方法
- ##### 创建ClusterIP类型的Service
首先为应用创建一下ClusterIP类型的Service。
```
apiVersion: v1
kind: Service
metadata:
  name: jenkins-service
  labels:
    name: jenkins-service
spec:
  type: ClusterIP
  ports:
  - name: port
    port: 8080
    targetPort: 8080
  selector:
    name: jenkins-blueocean
```
- ##### 修改 tcp configmap
在左上角选择工程`System`，然后在`Resource`里选择`Config Maps`，找到下面的`tcp-services`，然后编辑，如下图：
![](http://seafile.kodgames.net/repo/3b166c5a-420c-430e-bd42-731e598e9596/raw/%E5%91%A8%E5%A2%9E%E6%B3%95/images/nginx-ingress-tcp-edit.png)
点击`edit`，打开如下图
![](http://seafile.kodgames.net/repo/3b166c5a-420c-430e-bd42-731e598e9596/raw/%E5%91%A8%E5%A2%9E%E6%B3%95/images/nginx-ingress-tcp-config.png)
设置完成后，可使用集群的使用`172.16.2.251:3672`即可访问。

参考文档：
https://kubernetes.github.io/ingress-nginx/user-guide/exposing-tcp-udp-services/
https://yq.aliyun.com/articles/603225

