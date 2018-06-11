**防火墙设置**
- 开启防火墙
sudo service iptables start
- 允许172.28网段访问2181端口
iptables -A INPUT -s 172.28.0.0/16 -p tcp --dport 2181 -j ACCEPT
- 限制其他IP访问2181端口
iptables -A INPUT -p tcp --dport 2181 -j DROP
