**文档迭代**

|  更新日期 | 操作人员  | 更新描述  |
| ------------ | ------------ | ------------ |
|  2018/12/10 |周增法    | 创建文档  |

# 如何创建namespace

* Yaml文件创建方式
保存如下脚本文件到ns.yaml
```
apiVersion: v1
kind: Namespace
metadata:
   name: new-namespace
```
然后执行：
```
kubectl create -f ns.yaml
```

* 命令创建方式
```
kubectl create ns new-namespace
```
