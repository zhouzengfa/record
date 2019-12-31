**文档迭代**

|  更新日期 | 操作人员  | 更新描述  |
| ------------ | ------------ | ------------ |
|  2018/11/170|周增法    | 创建文档  |

# 如何使用Ingress

使用ingress可以实现域名+路径的方式实现对服务器的访问，避免了使用Service对外访问IP+端口这种与集群Ip地址强耦合的访问方式，实现了访问与集群Ip地址的解耦。

Ingree的ymal示例如下：
```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: test-ingress
spec:
  rules:
  - host: foo.bar.com
    http:
      paths:
      - path: /foo
        backend:
          serviceName: s1 #Service 名字
          servicePort: 80 #Service的端口
      - path: /bar
        backend:
          serviceName: s2
          servicePort: 80
```
执行脚本后，可以使用`http://foo.bar.com/foo`访问Service

完整示例请参考[k8s部署jenkins](http://seafile.kodgames.net/lib/3b166c5a-420c-430e-bd42-731e598e9596/file/%E5%91%A8%E5%A2%9E%E6%B3%95/k8s%E9%83%A8%E7%BD%B2Jenkins.md "k8s部署jenkins")

