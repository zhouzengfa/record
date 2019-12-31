**文档迭代**

|  更新日期 | 操作人员  | 更新描述  |
| ------------ | ------------ | ------------ |
|  2018/10/20 |周增法    | 创建文档  |


# 如何使用ConfigMap

ConfigMap是用于保存配置数据的键值对，可以用来保存单个属性，也可以用来保存配置文件。ConfigMap跟secret很类似，但它可以更方便地处理不包含敏感信息的字符串。

使用示例如下：

- ## 创建ConfigMap##
通过命令创建ConfigMap
	- 使用文件创建 
需要事先创建一个名为password的文件，内放要使用的内容。
```
 kubectl create configmap my-config --from-file=password  
```
	- 使用字面值创建
```
kubectl create configmap my-config --from-literal=user=root --from-literal=password=abc
```
- ## 以环境变量方式引用##
```
apiVersion: batch/v1
kind: Job
metadata:
  name: my-configmap-test
  labels:
    app: configmap
spec:
  template:
    metadata:
      labels:
        app: configmap
    spec:
      restartPolicy: Never
      containers:
      - image: registry.loho.local:5000/busybox
        name: configmap
        command: [ "/bin/sh", "-c", "echo $(ROOT_PASSWORD)" ]
        env:
        - name: ROOT_PASSWORD
          valueFrom:
            configMapKeyRef:
              name: my-config
              key: password
```
- ## 使用volume将ConfigMap作为文件或目录直接挂载##
```
apiVersion: batch/v1
kind: Job
metadata:
  name: my-configmap-test
  labels:
    app: configmap
spec:
  template:
    metadata:
      labels:
        app: configmap
    spec:
      restartPolicy: Never
      containers:
        - name: configmap
          image: registry.loho.local:5000/busybox
          command: [ "/bin/sh", "-c", "cat /etc/config/password" ]
          volumeMounts:
          - name: config-volume
            mountPath: /etc/config
      volumes:
        - name: config-volume
          configMap:
            name: my-config
```


- ## ConfigMap的更新 ##
使用命令
```
kubectl edit configmap my-config
```
编辑后保存即可。
更新 ConfigMap 后:
	- 使用该 ConfigMap 挂载的 Env 不会同步更新
	- 使用该 ConfigMap 挂载的 Volume 中的数据需要一段时间（实测大概10秒）才能同步更新
	
参考文档：https://www.kubernetes.org.cn/configmap