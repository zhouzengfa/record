# 源码安装nginx
* 需要的依赖

  ```shell
  yum -y install pcre-devel openssl openssl-devel
  
  
  ```

* 安装

  ```shell
  wget http://nginx.org/download/nginx-1.14.0.tar.gz
  tar -xzf nginx-1.14.0.tar.gz
  cd nginx-1.14.0
  ./configure --user=root --group=root --prefix=/usr/local/nginx --with-http_ssl_module --with-http_stub_status_module --with-http_realip_module --with-threads
  make -j 2 && make install
  ln -s /usr/local/nginx/sbin/nginx /usr/bin/nginx
  ```
* 起动

  ```shell
  nginx
  ```

* 测试配置是否正确

  ```
  nginx -t
  ```

* 重新加载配置

  ```
  nginx -s reload
  ```