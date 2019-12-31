**文档迭代**

|  更新日期 | 操作人员  | 更新描述  |
| ------------ | ------------ | ------------ |
|  2018/12/16 |周增法    | 创建文档  |

# NFS服务器配置

#### 一、安装nfs服务和rpcbind服务
```
yum -y install nfs-utils rpcbind
```
#### 二、设置设置共享目录的访问权限
```
 mkdir -p /nfs-share 
 chmod a+w /nfs-share
 ``` 
#### 三、 配置共享目录
  - 在nfs服务器中为客户端配置共享目录
  ```
  echo "/nfs-share *(rw,async,no_root_squash)" >> /etc/exports
  ```
  - 通过执行如下命令是配置生效
  ```
  exportfs -r
```

#### 四、启动服务
必须先启动rpcbind服务，再启动nfs服务，这样才能让nfs服务在rpcbind服务上注册成功
- 启动rpcbind服务
```
systemctl start rpcbind
```
- 启动nfs服务
```
systemctl start nfs-server
```
- 设置rpcbind和nfs-server开机启动
```
 systemctl enable rpcbind
 systemctl enable nfs-server
 ```
- 检查nfs服务是否正常启动
```
 showmount -e localhost
 ```
 
参考文档：
https://www.kubernetes.org.cn/4022.html
