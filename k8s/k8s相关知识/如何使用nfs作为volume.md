**文档迭代**

|  更新日期 | 操作人员  | 更新描述  |
| ------------ | ------------ | ------------ |
|  2018/12/16 |周增法    | 创建文档  |


# 如何使用NFS作为Volume

NFS可以直接作为存储卷使用，下面是一个busybox部署的YAML配置文件。在此示例中，busybox在容器中的持久化数据保存在/mnt目录下；存储卷使用nfs，nfs的服务地址为：172.16.2.45，存储路径为： /home/nfs-share

使用示例如下：
```
apiVersion: apps/v1
kind: Deployment
metadata:  
  name: busybox-deployment
  namespace: develop
spec:  
  replicas: 2  
  selector:
    matchLabels:
      name: busybox-deployment
  template:    
    metadata:      
      labels:        
        name: busybox-deployment    
    spec:      
      containers:      
      - image: busybox        
        command:          
        - sh          
        - -c          
        - 'while true; do date > /mnt/index.html; hostname >> /mnt/index.html; sleep $(($RANDOM % 5 + 5)); done'        
        imagePullPolicy: IfNotPresent        
        name: busybox        
        volumeMounts:         
        - name: nfs            
          mountPath: "/mnt" 
      volumes:      
      - name: nfs  
        nfs:
          path: /home/nfs-share
          server: 172.16.2.45
```

	
参考文档：
https://www.kubernetes.org.cn/4022.html