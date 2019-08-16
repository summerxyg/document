```
select host, user, password from mysql.user;
set password for xxl-job@% = password('Infosky@65669939');

# 下载mysql5.7安装包
wget wget -P /app/cargo/install https://cdn.mysql.com//Downloads/MySQL-5.7/mysql-5.7.27-1.el6.x86_64.rpm-bundle.tar
# 查看是否安装了旧版mysql
rpm -qa | grep mysql
# rpm -e --nodeps {-file-name} 逐个删除
# 解压
tar -xvf mysql-5.7.27-1.el6.x86_64.rpm-bundle.tar
# rpm -ivh {-file-name} 逐个安装
# 启动
service mysqld start
# 查看root用户随机密码
grep 'temporary password' /var/log/mysqld.log
# 开放mysql端口
iptables -I INPUT 1 -p tcp --dport 3306 -j ACCEPT

# MySql中创建一个用户
mysql> CREATE USER 'test'@'%' IDENTIFIED BY 'test123';
mysql> GRANT ALL PRIVILEGES ON *.* TO 'test'@'%' WITH GRANT OPTION;
mysql> flush privileges;
```

- RPM安装MySql时的默认路径

 * 数据文件：/var/lib/mysql/

 * 配置文件模板：/usr/share/mysql mysql

 * 客户端工具目录：/usr/bin

 * 日志目录：/var/log/pid