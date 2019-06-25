```
# 查看磁盘空间
df -h
# 查看CPU信息
cat /proc/cpuinfo
# 查看版本当前操作系统内核信息
uname -a

# 查看系统参数
ulimit -a
# 修改最大文件打开数
vi /etc/security/limits.conf
# 添加以下内容
root soft nofile 65535
root hard nofile 65535
* soft nofile 65535
* hard nofile 65535
# 修改最大进程数
vi /etc/security/limits.d/90-nproc.conf
# 添加以下内容
*          soft    nproc     4096
root       soft    nproc     unlimited

# 查看系统服务
chkconfig --list
# 启动/停止防火墙
service iptables start
service iptables stop
# 为防火墙配置访问策略
## 查看访问规则
iptables -L
## 清除访问规则
iptables -F
## 删除规则6
sudo iptables -D INPUT 6
## 开放出口
iptables -P OUTPUT ACCEPT
## 允许所有访问21,22,80端口
iptables -A INPUT -p tcp --dport 21 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
## 允许172.21网段访问（内网白名单）
iptables -A INPUT -s 172.21.0.0/16 -j ACCEPT
## 允许172.21.129网段访问（内网白名单）
iptables -A INPUT -s 172.21.129.0/24 -j ACCEPT
## 允许127.0.0.1回环访问
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
## 最后禁止其他未允许的规则访问
iptables -P INPUT DROP

## 清除访问规则
iptables -F
## 开放出口
iptables -P OUTPUT ACCEPT
## 允许所有访问21,22,80端口
iptables -A INPUT -p tcp --dport 21 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 7003 -j ACCEPT
## 允许172.28.20网段访问（内网白名单）
iptables -A INPUT -s 172.28.20.0/24 -j ACCEPT
## 允许127.0.0.1回环访问
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
## 最后禁止其他未允许的规则访问
iptables -P INPUT DROP

# 启动/停止FTP
service vsftpd start
service vsftpd stop
# 为FTP配置访问策略
vi /etc/vsftpd/vsftpd.conf
# 关闭匿名帐号，找到并修改成以下内容
anonymous_enable=NO
# 允许本地用户登录FTP服务器
local_enable=YES
## 添加以下内容，为不同的用户配置不同的访问目录
user_config_dir=/etc/vsftpd/userconfig
## 在userconfig目录下以用户名作为文件名创建文件，并添加以下内容
local_root=/var/ftp/user1/

## yum源不可用时，配置本地yum源


# 创建普通用户
useradd cargo
passwd cargo
# 创建FTP用户
useradd  -d /opt/ftp/root -s /sbin/nologin -g ftpgroup ftpuser
passwd ftpuser

# 编辑/etc/sudoers为用户授权
vi /etc/sudoers
# 添加以下内容
cargo   ALL=(ALL)       ALL

```
