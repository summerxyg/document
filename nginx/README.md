- 下载安装文件(nginx， pcre)

- 准备工作
```
# 安装make
yum -y install gcc automake autoconf libtool make
# 安装gcc
yum install gcc gcc-c++
```
- 安装
```
# 安装pcre
cd /opt/app/pcre-8.30
./configure && make && make install
# 安装nginx
cd /opt/app/nginx-1.5.7
./configure --prefix=/opt/app/nginx-1.5.7 --with-http_ssl_module --with-pcre=/opt/app/pcre-8.30 --with-zlib=/usr/local/zlib-1.2.11 --with-openssl=/usr/local/openssl-1.0.1t
make && make install
```

