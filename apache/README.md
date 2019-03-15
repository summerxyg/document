## [Apache安装与配置] ##

- 安装
 * 下载httpd, apr, apr-util, pcre
 * 安装
 * [配置]
 * 启动
```
// 下载 & 解压 & 编译
wget -P /opt/install http://mirrors.shu.edu.cn/apache//httpd/httpd-2.4.37.tar.gz
wget -P /opt/install http://mirrors.hust.edu.cn/apache//apr/apr-1.6.5.tar.gz
wget -P /opt/install http://mirrors.hust.edu.cn/apache//apr/apr-1.6.5.tar.gz
wget -P /opt/install https://nchc.dl.sourceforge.net/project/pcre/pcre/8.42/pcre-8.42.tar.gz

tar xzvf apr-1.6.5.tar.gz
cd apr-1.6.5
./configure --prefix=/opt/app/apr-1.6.5
make & make install


```