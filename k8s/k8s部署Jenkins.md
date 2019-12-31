**文档迭代**

|  更新日期 | 操作人员  | 更新描述  |
| ------------ | ------------ | ------------ |
|  2018/11/10 |周增法    | 创建文档  |

# k8s 部署 Jenkins

* 配置k8s权限
保存~/.kube/config 到目录/tmp下的config文件中，并在/tmp下执行命令
```
 kubectl create secret generic jenkins-kube-secret --from-file=config -n jenkins
 ```
* 部署Jenkins
执行如下脚本：

```
apiVersion: extensions/v1beta1
kind: Deployment
metadata: 
  name: jenkins-blueocean
  namespace: jenkins
spec: 
  replicas: 1
  template: 
    metadata: 
      labels: 
        name: jenkins-blueocean
    spec:  
      securityContext:
        runAsUser: 0
        fsGroup: 0
      nodeName: rancher-node1
      volumes:
      - name: jenkins-home
        hostPath:
          path: /data/jenkins/data
      - name: maven-repository
        hostPath:
          path: /data/jenkins/maven-repository
      #- name: docker
      #  hostPath:
      #    path: /usr/bin/docker
      - name: docker-sock
        hostPath:
          path: /var/run/docker.sock
      - name: kube-config
        secret:
          secretName: jenkins-kube-secret
      containers:
        - name: jenkins-blueocean
          imagePullPolicy: Always
          image: registry.loho.local/docker.io/jenkinsci/blueocean:1.8.4
          ports:
          - containerPort: 8080
          volumeMounts:
          - name: jenkins-home
            mountPath: /var/jenkins_home
          - name: maven-repository
            mountPath: /opt/maven/repository
          #- name: docker
          #  mountPath: /usr/bin/docker
          - name: docker-sock
            mountPath: /var/run/docker.sock
          - name: kube-config
            mountPath: "/root/.kube/"
            readOnly: true
          env:
          - name: JAVA_OPTS
            value: "-Duser.timezone=Asia/Shanghai"
---
apiVersion: v1
kind: Service
metadata:
  name: jenkins-service
  namespace: jenkins
  labels:
    name: jenkins-service
spec:
  type: NodePort 
  ports:
  - name: port
    port: 8080
    targetPort: 8080
    nodePort: 30657
  - name: jnlp
    nodePort: 30660
    port: 30660
    protocol: TCP
    targetPort: 30660
  selector:
    name: jenkins-blueocean
#  externalIPs:
#  - 172.16.1.183
---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: jenkins-ingress
  namespace: jenkins
spec:
  rules:
  - host: jenkins.k8s.loho.local
    http:
      paths:
      - path: /
        backend:
          serviceName: jenkins-service
          servicePort: 8080

```
此脚本会生成一个Jenkins Pod、一个service、一个ingress。部署成功后，在ie输入`jenkins.k8s.loho.local`可进行对Jenkins的访问。