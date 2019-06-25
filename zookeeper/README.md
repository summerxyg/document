**防火墙设置**
- 开启防火墙
sudo service iptables start
- 允许172.28网段访问2181端口
iptables -A INPUT -s 172.28.0.0/16 -p tcp --dport 2181 -j ACCEPT
- 限制其他IP访问2181端口
iptables -A INPUT -p tcp --dport 2181 -j DROP

- 限制ip访问
./zkCli.sh -server 127.0.0.1:2181
create /aclTest 1

setAcl / world:anyone:cdrwa

setAcl / ip:172.28.20.153:cdrwa,ip:172.28.20.154:cdrwa,ip:172.28.20.155:cdrwa,ip:172.28.20.156:cdrwa,ip:172.28.20.157:cdrwa,ip:172.28.20.158:cdrwa,ip:172.28.20.151:cdrwa,ip:172.28.20.152:cdrwa
setAcl /conf ip:172.28.20.153:cdrwa,ip:172.28.20.154:cdrwa,ip:172.28.20.155:cdrwa,ip:172.28.20.156:cdrwa,ip:172.28.20.157:cdrwa,ip:172.28.20.158:cdrwa

setAcl / ip:172.21.0.0/16:cdrwa

setAcl / ip:172.28.20.132:cdrwa,ip:172.28.20.133:cdrwa,ip:172.28.20.134:cdrwa,ip:172.28.20.135:cdrwa,ip:172.28.20.136:cdrwa,ip:172.28.20.137:cdrwa


## 129.67的ZK（测试）
setAcl / ip:172.21.129.67:cdrwa,ip:172.21.129.68:cdrwa
## 118.62的ZK（开发）
setAcl / ip:172.21.118.62:cdrwa,ip:172.21.118.63:cdrwa,ip:172.21.118.64:cdrwa
## 118.47的ZK（测试）
setAcl / ip:172.21.118.47:cdrwa,ip:172.21.118.48:cdrwa,ip:172.21.118.80:cdrwa,ip:172.28.20.152:cdrwa

- 查看统计信息
echo stat | nc 172.28.20.153 2181

- 开机自启动
```
touch /etc/rc.d/init.d/zookeeper
chmod +x /etc/rc.d/init.d/zookeeper
chkconfig zookeeper on
vi /etc/rc.d/init.d/zookeeper

#!/bin/bash
#chkconfig:2345 20 90
#description:zookeeper
#processname:zookeeper
case $1 in
          start) /opt/app/zookeeper-3.4.6/bin/zkServer.sh start;;
          stop) /opt/app/zookeeper-3.4.6/bin/zkServer.sh stop;;
          status) /opt/app/zookeeper-3.4.6/bin/zkServer.sh status;;
          restart) /opt/app/zookeeper-3.4.6/bin/zkServer.sh restart;;
          *) echo "require start|stop|status|restart";;
esac
```
