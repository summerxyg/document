- 安装shadowsocks
```
sudo apt-get -y install python-gevent python-pip
sudo pip install shadowsocks
sudo apt-get -y install python-m2crypto
```
- 配置shadowsocks
```
sudo mkdir /opt/app/shadowsocks
sudo vi /opt/app/shadowsocks/shadowsocks.json
```
- shadowsocks.json
```
{
   "server":"0.0.0.0",
   "port_password":{
        "8388":"password1",
        "8389":"password2",
        "443":"password3"
   },
   "timeout":300,
   "method":"aes-256-cfb",
   "fast_open":false,
   "workers":1
}
```

- 启动 & 停止
```
ssserver -c /opt/app/shadowsocks/shadowsocks.json -d start
ssserver -c /opt/app/shadowsocks/shadowsocks.json -d stop
```

