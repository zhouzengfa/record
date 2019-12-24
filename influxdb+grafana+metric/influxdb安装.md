# yum方式安装influxdb

##### 1.添加yum仓库
```shell
cat <<EOF | sudo tee /etc/yum.repos.d/influxdb.repo
[influxdb]
name = InfluxDB Repository - RHEL \$releasever
baseurl = https://repos.influxdata.com/rhel/\$releasever/\$basearch/stable
enabled = 1
gpgcheck = 1
gpgkey = https://repos.influxdata.com/influxdb.key
EOF
```

##### 2.yum安装
```shell
yum install -y influxdb
```

##### 3.起动
```shell
systemctl start influxdb
```