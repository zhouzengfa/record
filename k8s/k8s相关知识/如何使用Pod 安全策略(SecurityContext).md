**文档迭代**

|  更新日期 | 操作人员  | 更新描述  |
| ------------ | ------------ | ------------ |
|  2018/11/30 |周增法    | 创建文档  |

# 如何使用Pod 安全策略(SecurityContext)
SecurityContext，即安全上下文，它用于定义Pod或Container的权限和访问控制设置，通过用户ID（UID）和组ID（GID）来限制其访问资源（如：文件）的权限。

- **针对pod设置**
```
apiVersion: v1
kind: Pod
metadata:
  name: security-context-demo
spec:
  securityContext:
    runAsUser: 1000
    fsGroup: 2000
  volumes:
  - name: sec-ctx-vol
    emptyDir: {}
  containers:
  - name: sec-ctx-demo
    image: gcr.io/google-samples/node-hello:1.0
    volumeMounts:
    - name: sec-ctx-vol
      mountPath: /data/demo
    securityContext:
      allowPrivilegeEscalation: false
```
- **针对container设置**
```
apiVersion: v1
kind: Pod
metadata:
  name: security-context-demo-2
spec:
  securityContext:
    runAsUser: 1000
  containers:
  - name: sec-ctx-demo-2
    image: gcr.io/google-samples/node-hello:1.0
    securityContext:
      runAsUser: 2000
      allowPrivilegeEscalation: false
```
- **用户及组创建**
 - 创建组
 ```
 groupadd jenkins
 ```
 - 创建用户并加入组
```
useradd -g jenkins jenkinsuser
```
 - 设置用户密码
```
passwd jenkinsuser
```
 - 修改文件夹拥有者
```
chown -R jenkins:jenkinsuser /data
```
 - 查组信息
```
id 组名或组ID
```
 
参考文档：
http://bazingafeng.com/2017/12/23/kubernetes-uses-the-security-context-and-sysctl/