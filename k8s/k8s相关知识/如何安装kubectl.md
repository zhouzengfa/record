**文档迭代**

|  更新日期 | 操作人员  | 更新描述  |
| ------------ | ------------ | ------------ |
|  2018/7/24 |周增法    | 创建文档  |


# Centos 如何安装kubectl



- 打开控制台，输入如下命令
```
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
```
等待下载完成。

- 修改执行权限
```
chmod +x ./kubectl
```

- 移动到/usr/bin下
```
mv kubectl /usr/bin/
```
