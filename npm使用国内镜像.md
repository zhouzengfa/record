# npm使用国内淘宝镜像的方法
### 一.通过命令配置验证
##### 1. 命令
```
npm config set registry https://registry.npm.taobao.org
```
##### 2. 验证命令
```
npm config get registry
```
如果返回https://registry.npm.taobao.org，说明镜像配置成功。
或者
```
cnpm -v
```
有返回信息不报错就配置成功了

### 二.通过使用npm安装
##### 1. 安装cnpm
```
npm install -g cnpm --registry=https://registry.npm.taobao.org
```
##### 2. 使用cnpm
```
cnpm install xxx
```