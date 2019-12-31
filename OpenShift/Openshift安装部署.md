**文档迭代**

|  更新日期 | 操作人员  | 更新描述  |
| ------------ | ------------ | ------------ |
|  2018/12/16 |周增法    | 创建文档  |

# openshift 3.10安装部署

openshift 3.10(OKD) 安装配置步骤，可能不适合于其它版本

## 一、配置清单

| 类型| 主机名  | IP  |
| ------------ | ------------ | ------------ |
| Master  | master.example.com   | 172.16.2.157  |
|Node   | node01.example.com   |  172.16.2.156 |
| Node  |  node02.example.com | 172.16.2.34  |

## 二、节点配置
以下列示的步骤需要在所有节点上实施。
- 开启SELINUX
修改/etc/selinux/config
```
SELINUX=enforcing
SELINUXTYPE=targeted
```
- 添加 Host 映射 
修改/etc/hosts 在后面添加
```
172.16.2.157 master.example.com master
172.16.2.157 nfs.example.com
172.16.2.156 lb.example.com
172.16.2.156 node01.example.com node01
172.16.2.34 node02.example.com node02
```
- 安装基础软件包
```
yum -y install docker git wget net-tools bind-utils iptables-services bridge-utils bash-completion kexec-tools sos psacct
```
- 设置 Docker 为开机自启动并启动 Docker 守护进程
```
systemctl enable docker
systemctl start docker
```

## 三、Master操作步骤
以下步骤仅在master上实施
- 配置 SSH 免密码登陆
```
ssh-keygen -f ~/.ssh/id_rsa -N ''
for host in master.example.com node01.example.com node02.example.com
do
    ssh-copy-id -i ~/.ssh/id_rsa.pub $host;
done
```
- 克隆仓库 openshift-ansible
```
git clone -b release-3.10 https://github.com/openshift/openshift-ansible.git /usr/share/openshift-ansible
```
- 安装 Ansible
```
yum install -y epel-release
yum repolist
yum install -y ansible pyOpenSSL python-cryptography python-lxml
```
- 配置 ansible 文件
编辑/etc/ansible/hosts 在最后加入如下配置

```
# Create an OSEv3 group that contains the masters and nodes groups
[OSEv3:children]
masters
nodes
etcd
lb
nfs

# Set variables common for all OSEv3 hosts
[OSEv3:vars]
# SSH user, this user should allow ssh based auth without requiring a password
ansible_ssh_user=root
# If ansible_ssh_user is not root, ansible_become must be set to true
#ansible_become=true
openshift_deployment_type=origin
#openshift_deployment_type=openshift-enterprise

openshift_enable_unsupported_configurations=True
openshift_hosted_registry_storage_kind=nfs
openshift_hosted_registry_storage_access_modes=['ReadWriteMany']
openshift_hosted_registry_storage_nfs_directory=/exports
openshift_hosted_registry_storage_nfs_options='*(rw,root_squash)'
openshift_hosted_registry_storage_volume_name=registry
openshift_hosted_registry_storage_volume_size=10Gi

openshift_metrics_install_metrics=true
openshift_metrics_hawkular_hostname=hawkular-metrics.example.com
openshift_metrics_storage_kind=nfs
openshift_metrics_storage_access_modes=['ReadWriteOnce']
openshift_metrics_storage_nfs_directory=/exports
openshift_metrics_storage_nfs_options='*(rw,root_squash)'
openshift_metrics_storage_volume_name=metrics
openshift_metrics_storage_volume_size=10Gi


# Specify the generic release of OpenShift to install. This is used mainly just during installation, after which we
# rely on the version running on the first master. Works best for containerized installs where we can usually
# use this to lookup the latest exact version of the container images, which is the tag actually used to configure
# the cluster. For RPM installations we just verify the version detected in your configured repos matches this
# release.
openshift_release=v3.10

#penshift_disable_check=disk_availability,docker_storage,memory_availability,docker_image_availability
penshift_disable_check=disk_availability,docker_storage,memory_availability,docker_image_availability

# Specify an exact container image tag to install or configure.
# WARNING: This value will be used for all hosts in containerized environments, even those that have another version installed.
# This could potentially trigger an upgrade and downtime, so be careful with modifying this value after the cluster is set up.
openshift_image_tag=v3.10.0
# Specify an exact rpm version to install or configure.
# WARNING: This value will be used for all hosts in RPM based environments, even those that have another version installed.
# This could potentially trigger an upgrade and downtime, so be careful with modifying this value after the cluster is set up.
openshift_pkg_version=-3.10.0
# uncomment the following to enable htpasswd authentication; defaults to DenyAllPasswordIdentityProvider
#openshift_master_identity_providers=[{'name': 'htpasswd_auth', 'login': 'true', 'challenge': 'true', 'kind': 'HTPasswdPasswordIdentityProvider', 'filename': '/etc/origin/master/htpasswd'}]
# Default login account: admin / handhand
#openshift_master_htpasswd_users={'admin': '$apr1$gfaL16Jf$c.5LAvg3xNDVQTkk6HpGB1'}

# Specify exact version of etcd to configure or upgrade to.
#etcd_version="3.1.9"
#openshift_repos_enable_testing=true
openshift_disable_check=disk_availability,docker_storage
docker_selinux_enabled=false
openshift_docker_options=" --log-driver=journald --storage-driver=overlay --registry-mirror=http://4a0fee72.m.daocloud.io "
# OpenShift Router Options
# Router selector (optional)
# Router will only be created if nodes matching this label are present.
# Default value: 'region=infra'
openshift_hosted_router_selector='region=infra,router=true'
# default subdomain to use for exposed routes
openshift_master_default_subdomain=app.example.com

openshift_node_groups=[{'name': 'masters', 'labels': ['node-role.kubernetes.io/master=true', 'node-role.kubernetes.io/infra=true', 'node-role.kubernetes.io/compute=true']},{'name': 'nodes', 'labels': ['node-role.kubernetes.io/node=true'
, 'node-role.kubernetes.io/infra=true', 'node-role.kubernetes.io/compute=true']}]

[nfs]
master.example.com

[masters]
master.example.com

# host group for etcd
[etcd]
master.example.com

# Load balancers
[lb]
lb.example.com

# host group for nodes, includes region info
[nodes]
master.example.com openshift_schedulable=true openshift_node_group_name='masters'
node01.example.com openshift_schedulable=true openshift_node_group_name='nodes'
node02.example.com openshift_schedulable=true openshift_node_group_name='nodes'
```
- 修改文件
因为OKD需要的master最小内存为16G，node内存为8G，若内存足够，请忽略此步骤。若不足，可修改文件openshift-ansible/roles/openshift_health_checker/openshift_checks/memory_availability.py中相应数值。

- 验证安装条件
```
 ansible-playbook -i /etc/ansible/hosts /usr/share/openshift-ansible/playbooks/prerequisites.yml 
 ```
- 安装
```
ansible-playbook -i /etc/ansible/hosts /usr/share/openshift-ansible/playbooks/deploy_cluster.yml
```
- 安装完成之后可以查看pod的状态。
```
oc get all --all-namespaces
```
成功后，如下图：
![](http://seafile.kodgames.net/repo/3b166c5a-420c-430e-bd42-731e598e9596/raw/%E5%91%A8%E5%A2%9E%E6%B3%95/images/openshift_install_success.png)

- 在本机配置 hosts 映射
Windows 操作系统下编辑 C:\Windows\System32\drivers\etc\hosts
Linux / macOS 操作系统下编辑 /etc/hosts
添加一下内容：
```
172.16.2.157 master.example.com
```
- 访问 OpenShift Origin 主页
访问以下地址确保 OpenShift Origin 可以正确访问： https://master.example.com:8443/
用户账户： admin / admin

## 四、注意：
如果安装过程 中，因某个镜像拉不下来，导致安装失败，可先在Master节点先拉下来。如：
```
 docker pull quay.io/coreos/etcd:v3.2.22
 ```
 先把etcd拉到本地。
 
 五、参考文档：
https://www.jianshu.com/p/b0a60fca1977
https://blog.csdn.net/huqigang/article/details/82351972
https://cloud.tencent.com/developer/article/1008861