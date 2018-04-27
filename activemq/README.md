## 1. [ActiveMQ](http://activemq.apache.org/)
 - [安装](http://activemq.apache.org/getting-started.html#GettingStarted-InstallationProcedureforUnix)
 - 下载解压
 - 启动
 - 创建队列
```
// 下载解压
scp cargo@172.21.118.64:/opt/install/apache-activemq-5.14.1-bin.tar.gz /opt/install
wget -P /opt/install https://archive.apache.org/dist/activemq/5.14.1/apache-activemq-5.14.1-bin.tar.gz
tar -zxvf /opt/install/apache-activemq-5.14.1-bin.tar.gz -C /opt/app
// 开启activemq端口8161（管理平台端口）和61616（通讯端口）
sudo iptables -I INPUT -p tcp --dport 8161 -j ACCEPT
sudo iptables -I INPUT -p tcp --dport 61616 -j ACCEPT
// 启动
cd /opt/app/apache-activemq-5.14.1
bin/activemq start
//访问、查看状态和停止
wget 172.21.118.62:8161
bin/activemq status
bin/activemq stop

// 开机启动
// 建立软链接
ln -s bin/activemq /etc/init.d/
vi /etc/init.d/activemq
// 添加以下内容
----------------------------------------
# chkconfig: 345 63 37
# description: Auto start ActiveMQ
JAVA_HOME=/usr/local/jdk1.8.0_144
JAVA_CMD=java
----------------------------------------
// 设置开机启动
chkconfig activemq on
```


浏览器访问http://172.21.129.36:8161/admin/