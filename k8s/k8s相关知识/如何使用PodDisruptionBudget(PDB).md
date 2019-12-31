**文档迭代**

|  更新日期 | 操作人员  | 更新描述  |
| ------------ | ------------ | ------------ |
|  2018/10/23 |周增法    | 创建文档  |

#  如何使用PodDisruptionBudget(PDB)
 
PDB是为了解决什么问题？
  有时为了高可用，我们需要保证一定数量的健康可用的Pod同时对外提供服务， 这非常适用于应用的滚动升级和集群的自动扩容。
 
 - PodDistuptionBudget的定义
 ```
 apiVersion: policy/v1beta1
kind: PodDisruptionBudget
metadata:
  name: zk-pdb
spec:
  minAvailable: 2 # 最小可用数量 
  selector:
    matchLabels:
      app: zookeeper #后端Pods Set，与应用对应的Deployment,StatefulSet的Selector一致
```
完整示例请参考[Zookeeper的部署与扩容](http://seafile.kodgames.net/lib/3b166c5a-420c-430e-bd42-731e598e9596/file/%E5%91%A8%E5%A2%9E%E6%B3%95/Zookeeper%E7%9A%84K8s%E9%83%A8%E7%BD%B2%E4%B8%8E%E6%89%A9%E5%AE%B9.md "Zookeeper的部署与扩容")
 
 参考文档：https://jimmysong.io/kubernetes-handbook/concepts/pod-disruption-budget.html