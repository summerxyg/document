## Redis安装与配置 (https://github.com/antirez/redis) ##
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
mkdir /opt/app/redis-cluster/redis-node6379
mkdir /opt/app/redis-cluster/redis-node6379/data
cp /opt/app/redis-3.2.1/redis.conf /opt/app/redis-cluster/redis-node6379/redis.conf
// 启动redis
redis-server /opt/app/redis-cluster/redis-node6379/redis.conf
// 测试
redis-cli -h 172.21.129.63 -p 6379
// 启用sentinel组件，这里省略了配置的修改，请根据实际情况修改配置
cp /opt/app/redis-3.2.1/sentinel.conf /opt/app/redis-cluster/redis-node6379/sentinel.conf
// 启动sentinel组件
redis-sentinel /opt/app/redis-cluster/redis-node6379/sentinel.conf

// 创建其他节点

// 安装redis集群管理工具
yum -y install ruby ruby-devel rpm-build
rpm -ivh http://yum.puppetlabs.com/el/5/products/x86_64/puppetlabs-release-5-6.noarch.rpm
yum -y install rubygems
gem install redis
/opt/app/redis-3.2.1/src/redis-trib.rb create 172.21.129.63:6379 172.21.129.63:6380 172.21.129.63:6381
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

**常见问题**
