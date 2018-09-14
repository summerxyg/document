 ```
 ## 检查是否已经安装vsftpd
 rpm -qa | grep vsftpd
 ## 安装
 yum -y install vsftpd
 ## 开机自启动
 chkconfig vsftpd on
 ## 启动
 service vsftpd start

 ## 创建FTP用户，并设置密码
 useradd -d /home/ftpuser ftpuser
 passwd ftpuser
 ## 更改FTP用户的权限
 ## 限定用户test不能telnet，只能ftp
 usermod -s /sbin/nologin ftpuser
 ## 修改vsftpd.conf的配置
 vi /etc/vsftpd/vsftpd.conf
 ## 关闭匿名登录
 anonymous_enable=NO
 ## 限制访问自身目录
 chroot_list_enable=YES
 chroot_list_file=/etc/vsftpd/vsftpd.chroot_list
```

**vsftpd.conf常用配置**
```


```


