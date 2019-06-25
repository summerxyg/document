## [Redis安装与配置](https://github.com/antirez/redis) ##
  Redis是一个key-value存储系统。和Memcached类似，它支持存储的value类型相对更多，包括string(字符串)、 list(链表)、set(集合)和zset(有序集合)。这些数据类型都支持push/pop、add/remove及取交集并集和差集及更丰富的操作，而且这些操作都是原子性的。在此基础上，redis支持各种不同方式的排序。与memcached一样，为了保证效率，数据都是缓存在内存中。区别的是redis会周期性的把更新的数据写入磁盘或者把修改操作写入追加的记录文件，并且在此基础上实现了master-slave(主从)同步,当前 Redis的应用已经非常广泛

- 安装
 * 下载redis压缩包，解压
 * 编译
 * [配置](http://www.cnblogs.com/wenanry/archive/2012/02/26/2368398.html)
 * 启动redis
 * 启动sentinel组件 [[关于sentinel机制请参考这里]](https://segmentfault.com/a/1190000002680804)
```
// 下载 & 解压 & 编译
wget -P /opt/install http://download.redis.io/releases/redis-3.2.1.tar.gz
tar -zxvf /opt/install/redis-3.2.1.tar.gz -C /opt/app
cd /opt/app/redis-3.2.1
make & make install
// 修改sysctl.conf
su root
echo vm.overcommit_memory=1 >> /etc/sysctl.conf
exit

// 创建node6379，注意这里省略了配置的修改，请根据实际情况修改配置
mkdir /opt/app/redis-cluster
mkdir /opt/app/redis-cluster/node6379
mkdir /opt/app/redis-cluster/node6379/data
cp /opt/app/redis-3.2.1/redis.conf /opt/app/redis-cluster/node6379/redis.conf
// 启动redis
redis-server /opt/app/redis-cluster/node6379/redis.conf
// 测试
redis-cli -h 172.21.129.63 -p 6379
// 启用sentinel组件，这里省略了配置的修改，请根据实际情况修改配置
cp /opt/app/redis-3.2.1/sentinel.conf /opt/app/redis-cluster/node6379/sentinel.conf
// 启动sentinel组件
redis-sentinel /opt/app/redis-cluster/node6379/sentinel.conf

// 创建其他节点（略）
```

- 手工配置集群
```
// 进入redis client
redis-cli -c
// 和6380建立通信
cluster meet 172.21.129.63 6380
// 查看集群节点
cluster nodes
// 退出redis client，执行每个节点下的slots.sh批量分配hash slot（请根据实际节点数修改每个节点的slot数量）
/opt/app/redis-cluster/node6379/slots.sh
/opt/app/redis-cluster/node6380/slots.sh
// 进入redis client，确认集群是否正常
redis-cli -c
cluster info
```

-  使用redis集群管理工具配置集群
```
// 安装redis集群管理工具
yum -y install ruby ruby-devel rpm-build
rpm -ivh http://yum.puppetlabs.com/el/5/products/x86_64/puppetlabs-release-5-6.noarch.rpm
yum -y install rubygems
gem install redis
// 创建集群
/opt/app/redis-3.2.1/src/redis-trib.rb create 172.21.129.63:6379 172.21.129.63:6380 172.21.129.63:6381
// 分配hash slot
/opt/app/redis-3.2.1/src/redis-trib.rb reshard 172.21.129.63:6379
```

**常用命令**
```
// 创建集群
./redis-trib.rb create 172.21.129.63:6379 172.21.129.63:6380 172.21.129.63:6381
// 将172.21.129.63:16379作为slave加入集群
./redis-trib.rb add-node --slave 172.21.129.63:16379 172.21.129.63:6379
// 迁移哈希槽（删除一个node前需要将其持有的哈希槽全部迁移到其他node）
./redis-trib.rb reshard 172.21.129.63:6379
// 删除node
./redis-trib.rb del-node 172.21.129.63:16379 'node ID'
// 连接到redis（集群模式）
redis-cli -c -h 172.21.129.63 -p 6379

```

**redis.conf常用配置**
```
####### 端口
port 6379
####### AOF日志路径
dir /opt/app/redis-cluster/redis-node6379/data
####### 守护进程模式启动
daemonize yes
logfile /opt/app/redis-cluster/redis-node6379/redis.log
####### disable protected mode
protected-mode no
####### 允许redis支持集群模式
cluster-enabled yes
####### 节点配置文件，使用redis-trib.rb管理集群时自动维护
cluster-config-file redis-node6379.conf
####### 节点超时毫秒
cluster-node-timeout 15000
####### 开启AOF日志
appendonly yes
####### 密码 (使用sentinel时，master会变成slave，slave会变成master，需要同时设置这两个配置项。)
requirepass p@$$w0rd
masterauth p@$$w0rd
####### 作为那个Master的Slave
slaveof 172.21.129.63 6379
```

**sentinel.conf常用配置**
```
####### 端口
port 26379
####### sentinel监控的master node
sentinel monitor mymaster 172.21.129.63 6379 2
####### 守护进程模式启动
daemonize yes
logfile /opt/app/redis-cluster/redis-node6379/sentinel.log
####### disable protected mode
protected-mode no
####### master node密码
sentinel auth-pass mymaster p@$$w0rd
```

**redis开启启动**
```
touch /etc/rc.d/init.d/redis6379d
chmod +x /etc/rc.d/init.d/redis6379d
chkconfig redis6379d on
vi /etc/rc.d/init.d/redis6379d


#!/bin/sh
# chkconfig:   2345 90 10
# description:  Redis is a persistent key-value database
#
# Simple Redis init.d script conceived to work on Linux systems
# as it does use of the /proc filesystem.

REDISPORT=6379
EXEC=/usr/local/bin/redis-server
CLIEXEC=/usr/local/bin/redis-cli

PIDFILE=/var/run/redis_${REDISPORT}.pid
CONF="/opt/app/redis-cluster/redis-node${REDISPORT}/redis.conf"

case "$1" in
    start)
        if [ -f $PIDFILE ]
        then
                echo "$PIDFILE exists, process is already running or crashed"
        else
                echo "Starting Redis server..."
                $EXEC $CONF
        fi
        ;;
    stop)
        if [ ! -f $PIDFILE ]
        then
                echo "$PIDFILE does not exist, process is not running"
        else
                PID=$(cat $PIDFILE)
                echo "Stopping ..."
                $CLIEXEC -p $REDISPORT shutdown
                while [ -x /proc/${PID} ]
                do
                    echo "Waiting for Redis to shutdown ..."
                    sleep 1
                done
                echo "Redis stopped"
        fi
        ;;
    *)
        echo "Please use start or stop as first argument"
        ;;
esac
```

**常见问题**

**其他**
- Redis Desktop Manager