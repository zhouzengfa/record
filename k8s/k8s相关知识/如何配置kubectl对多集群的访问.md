**文档迭代**

|  更新日期 | 操作人员  | 更新描述  |
| ------------ | ------------ | ------------ |
|  2018/11/13 |周增法    | 创建文档  |

# 如何配置kubectl对多集群的访问
本文适用于配置kubectl访问多个集群或者对同一集群根据不同用户的权限对kubectl做权限设置。本文假设在~/.kube/目录下已存在config文件。若不存在，请参考[如何对kubectl做权限管理](http://seafile.kodgames.net/lib/3b166c5a-420c-430e-bd42-731e598e9596/file/%E5%91%A8%E5%A2%9E%E6%B3%95/k8s%E7%9B%B8%E5%85%B3%E7%9F%A5%E8%AF%86/%E5%A6%82%E4%BD%95%E5%AF%B9kubectl%E5%81%9A%E6%9D%83%E9%99%90%E7%AE%A1%E7%90%86.md "如何对kubectl做权限管理")或其它方式先生成config文件。

### 1. 创建ServiceAccount
```
kubectl create sa jenkins
```
此步完成后会生成相应的CA和Token，用于后续配置kubectl。

### 2. 创建角色
```
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  annotations:
    rbac.authorization.kubernetes.io/autoupdate: "true"
  name: cluster-role-reader
rules:
- apiGroups:
  - ""
  resources:
  - configmaps
  - endpoints
  - persistentvolumeclaims
  - pods
  - replicationcontrollers
  - replicationcontrollers/scale
  - serviceaccounts
  - services
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - ""
  resources:
  - bindings
  - events
  - limitranges
  - namespaces/status
  - pods/log
  - pods/exec
  - pods/status
  - replicationcontrollers/status
  - resourcequotas
  - resourcequotas/status
  verbs:
  - get
  - list
  - watch
````
此步可按需配置，用于设置kubectl的权限。

### 3. 角色绑定
关联角色与ServiceAccount
```
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: default:jenkins
subjects:
  - kind: ServiceAccount
    name: jenkins
    namespace: default
roleRef:
  kind: ClusterRole
  name:cluster-role-reader
  apiGroup: rbac.authorization.k8s.io
  ```

### 4. 生成配置
此脚本需要在~/.kube/下执行
```
#!/bin/bash

#获取Secret
TOKEN=$(kubectl get sa -n default jenkins -o go-template='{{range .secrets}}{{.name}}{{end}}')
echo $TOKEN

#获取CA
CA_CERT=$(kubectl get secret -n default ${TOKEN} -o yaml | awk '/ca.crt:/{print $2}')
echo $CA_CERT

# 注意这里，需要改为你的apiserver的地址
API_SERVER="https://172.16.2.252:6443"
echo $API_SERVER

kubectl config set-cluster jenkins-cluster --server=${API_SERVER} --certificate-authority=${CA_CERT}
sed -i 's/certificate-authority:/certificate-authority-data:/g' config
SECRET=$(kubectl -n default get secret ${TOKEN} -o go-template='{{.data.token}}')
kubectl config set-credentials jenkins --token=`echo ${SECRET} | base64 -d` --kubeconfig=config
kubectl config set-context jenkins-context --cluster=jenkins-cluster --user=jenkins --kubeconfig=config
#kubectl config use-context jenkins-context --kubeconfig=config
```
生成的配置如下：
通过命令`kubectl config view` 查看
```
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://172.16.2.252:6443
  name: jenkins-cluster
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://rancher-server.loho.local/k8s/clusters/c-gvlfs
  name: k8s-cluster
contexts:
- context:
    cluster: jenkins-cluster
    user: jenkins
  name: jenkins-context
- context:
    cluster: k8s-cluster
    user: u-ottmfnl3vc
  name: k8s-cluster
current-context: jenkins-context
kind: Config
preferences: {}
users:
- name: jenkins
  user:
    token: eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6ImplbmtpbnMtdG9rZW4tOTRidHciLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoiamVua2lucyIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6IjNiNGM3ODk2LWU2N2EtMTFlOC05YTU4LTMwOWMyMzlmYTY2ZiIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDpkZWZhdWx0OmplbmtpbnMifQ.LkU890BkIMg_JwITLtTNd1susSC-9vjrXx0C-Y8PPdZBmE3sstEadi0kyqJ2iXfZKQAFSEzOMBHsfQ1cUDXVOMRj1A53w98QX4WjYlzaEtE5k_-Y2tZ4cLQu6WxN0xmkIZ6V0fY-kcO4uWC6mUdhs_XOucipIwXUnwp-YxSFYFL9d-qShy6MjcjQuUoMNgtpggnfQfN9zJD4e6ZZeFzWibl8oK4UEdTk0exuffjaEq6PiDQfibSQeO4VA0KaWe8C3cDeYMm71CHquVzaLZZTNnONdq9BcFF52tUZysZ9fv3oOWXVimcEHI6rUVYYDxac4MnkPZs_zCRUj6asar2MPA
- name: u-ottmfnl3vc
  user:
    token: kubeconfig-u-ottmfnl3vc:zgzb69c749pdd66rkzvjzbvgc2j7sml69tqm2lgzznmld9bwvcjv6n
```
jenkins-cluster即是我们新加的集群。

#### 5. 集群切换
通过如下命令可实现不同集群的切换
```
kubectl config use-context jenkins-context
```
切换后，kubectl即对应到不用的集群上，且拥有相应ServiceAccount的操作权限。

