# redis数据导出导入方式之redis-dump



1.安装ruby高版本
```shell
# 安装rvm
yum install ruby rubygems ruby-devel -y
command curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -
curl -L get.rvm.io | bash -s stable
find / -name rvm.sh #/etc/profile.d/rvm.sh
source /etc/profile.d/rvm.sh
rvm requirements
source /usr/local/rvm/scripts/rvm

# 查看rvm库中已知的ruby版本
rvm list known

# 安装一个ruby版本
rvm install 2.3.3

# 使用一个ruby版本
rvm use 2.3.3

# 卸载一个版本
rvm remove 2.0.0

# 查看使用的版本
ruby --version
```
2.安装redis-dump工具
```
gem install redis-dump -V
```
3.redis-dump导出
```
redis-dump -u redis://localhost:6379 > 141.json
```
4.redis-load导入
```
cat 141.json | redis-load -u redis://localhost:6379
#若出现错误 ERROR (Yajl::ParseError): lexical error: invalid bytes in UTF8 string.
#加入-n参数，如：
#cat 141.json | redis-load -n -u redis://localhost:6379
```

参考：
https://github.com/delano/redis-dump/
https://www.cnblogs.com/Camiluo/p/10996934.html
https://www.cnblogs.com/hjfeng1988/p/7146009.html