**文档迭代**

|  更新日期 | 操作人员  | 更新描述  |
| ------------ | ------------ | ------------ |
|  2018/10/19 |周增法    | 创建文档  |

# 如何创建并使用Sceret
Secret解决了密码、token、密钥等敏感数据的配置问题，而不需要把这些敏感数据暴露到镜像或者Pod Spec中。Secret可以以Volume或者环境变量的方式使用。下面展示如何创建Secret及使用。

- ### Opaque Secret
Opaque类型的数据是一个map类型，要求value是base64编码格式：
```
$ echo -n "admin" | base64
YWRtaW4=
```
  - 用ymal文件的方式创建Secret      
 ```
apiVersion: v1
kind: Secret
metadata:
      name: mysql-pass
type: Opaque
data:
      password: YWRtaW4= #数据，以map的方式存储
  ```  
  - 用命令的方式创建Secret
  首先创建一个文件password，并写密码：admin，其后不能有空行。
  ```
  kubectl create secret generic mysql-pass --from-file=password
  ```

- ### 以环境变量的方式使用Secret示例
下面是mysql镜像如何从Secret获取密码数据的示例。
```
apiVersion: extensions/v1beta1 # for k8s versions before 1.9.0 use apps/v1beta2  and before 1.8.0 use extensions/v1beta1
kind: Deployment
metadata:
  name: mysql-test-secret
  labels:
    app: mysql
spec:
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - image: registry.loho.local:5000/mysql:5.7
        name: mysql
        env:
        - name: MYSQL_ROOT_PASSWORD
          valueFrom:             #从Secret中获取密码
            secretKeyRef:
              name: mysql-pass
              key: password
        ports:
        - containerPort: 3306
          name: mysql
```
- ### 以挂载卷的方式使用示例
```
apiVersion: v1
kind: Pod
metadata:
  labels:
    name: db
  name: db
spec:
  volumes:
  - name: secrets
    secret:
      secretName: mysecret
  containers:
  - image: gcr.io/my_project_id/pg:v1
    name: db
    volumeMounts:
    - name: secrets
      mountPath: "/etc/secrets"
      readOnly: true
    ports:
    - name: cp
      containerPort: 5432
      hostPort: 5432
```
参考文档：https://www.kubernetes.org.cn/secret