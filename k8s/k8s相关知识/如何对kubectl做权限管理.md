**文档迭代**

|  更新日期 | 操作人员  | 更新描述  |
| ------------ | ------------ | ------------ |
|  2018/11/12 |周增法    | 创建文档  |

#  如何对kubectl做权限管理
 
 下面展示通过RBAC实现对kubectl的权限管理。kubectl 默认情况下，是读取 ~/.kube/config 文件作为配置，和 k8s 的 apiserver 进行通信，用到的关键信息为config里的ca和token，ca 是用于验证 apiserver 的证书，token 用作身份验证。为了拿到ca和token，我们可以创建一个ServiceAccount，ServiceAccount默认会带一个Secret，Secret里有我们需要的ca和token。为了做权限控制，我们可以创建一个ClusterRole或Role，然后与创建的ServiceAccount绑定，最终实现kubectl与ServiceAccount关联，kubectl拥有的权限即为与ServiceAccount绑定的角色的权限。
 
 步骤如下：
#### 1.  创建 ServiceAccount
经过这一步之后，其实就有了 Secret 资源，这是因为，创建 ServiceAccount 后，k8s 会自动创建 Secret 资源，而 Secret 资源，有我们需要的证书等信息
```
kubectl create ns kubectl-privilege-test
kubectl create sa -n kubectl-privilege-test kubectl-serviceaccount
```

#### 2. 创建一个ClusterRole并绑定到ServiceAccount

```
 #ClusterRole
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
- apiGroups:
  - ""
  resources:
  - namespaces
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - ""
  resources:
  - pods/exec
  verbs:
  - create
- apiGroups:
  - apps
  resources:
  - daemonsets
  - deployments
  - deployments/scale
  - replicasets
  - replicasets/scale
  - statefulsets
  - statefulsets/scale
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - autoscaling
  resources:
  - horizontalpodautoscalers
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - batch
  resources:
  - cronjobs
  - jobs
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - extensions
  resources:
  - daemonsets
  - deployments
  - deployments/scale
  - ingresses
  - networkpolicies
  - replicasets
  - replicasets/scale
  - replicationcontrollers/scale
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - policy
  resources:
  - poddisruptionbudgets
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - networking.k8s.io
  resources:
  - networkpolicies
  verbs:
  - get
  - list
  - watch
---
#创建 ClusterRoleBinding，将 ClusterRole 的权限，绑定到 ServiceAccount
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: kubectl-privilege-test:kubectl-rolebind
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-role-reader
subjects:
- kind: ServiceAccount
  name: kubectl-serviceaccount
  namespace: kubectl-privilege-test
 ```
 
#### 3.生成配置：guest.config 
```
#!/bin/bash

#获取Secret
TOKEN=$(kubectl get sa -n kubectl-privilege-test kubectl-serviceaccount -o go-template='{{range .secrets}}{{.name}}{{end}}')
echo $TOKEN

#获取CA
CA_CERT=$(kubectl get secret -n kubectl-privilege-test ${TOKEN} -o yaml | awk '/ca.crt:/{print $2}')
echo $CA_CERT

# 注意这里，需要改为你的apiserver的地址
API_SERVER="https://172.16.2.252:6443"
echo $API_SERVER

cat <<EOF > guest.config
apiVersion: v1
kind: Config
clusters:
- name: cluster
  cluster:
    certificate-authority-data: $CA_CERT  #设置CA
    server: $API_SERVER
EOF

SECRET=$(kubectl -n kubectl-privilege-test get secret ${TOKEN} -o go-template='{{.data.token}}')
kubectl config set-credentials kubectluser --token=`echo ${SECRET} | base64 -d` --kubeconfig=guest.config
kubectl config set-context kubectl-context --cluster=cluster --user=kubectluser --kubeconfig=guest.config
kubectl config use-context kubectl-context --kubeconfig=guest.config
```
#### 4.把生成guest.config copy到~/.kube/下，并命令为config即可 

#### 5.验证
输入`kubectl get po` 可看输出的pod列表
 