# ELK

ELK平台是一个完整的日志分析解决方案，由这三个开源工具构建而成：Elasticsearch、Logstash、Kibana。

[传送门:原理与介绍](https://www.cnblogs.com/aresxin/p/8035137.html)

---

## Elasticsearch

Elasticsearch用于深度搜索和数据分析，它是基于Apache Lucene的分布式开源搜索引擎，无须预先定义数据结构就能动态地对数据进行索引

- 安装
```
# 下载
wget --no-cookie --no-check-certificate -P /app/cargo/install https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.2.0-linux-x86_64.tar.gz
# 解压
tar -zxvf /app/cargo/install/elasticsearch-7.2.0-linux-x86_64.tar.gz -C /app/cargo
```

- 配置
/etc/sysctl.conf
```
vm.max_map_count=262144
```
/etc/security/limits.d/90-nproc.conf
```
* soft nproc 4096
```
/etc/security/limits.conf
```
* soft nproc 8192
* hard nproc 32767
* soft nofile 16384
* hard nofile 65535
```
conf/elasticsearch.yml
```
network.host: 0.0.0.0
node.name: node-61
cluster.initial_master_nodes: ["node-61"]
```

- 启动
```
/app/cargo/elasticsearch-7.2.0/bin/elasticsearch
```
启动成功后，浏览器访问：http://localhost:9200


## Logstash

Logstash用于日志集中管理，包括从多台服务器上传输和转发日志，并对日志进行丰富和解析，是一个数据管道，提供了大量插件来支持数据的输入和输出处理

- 安装
```
# 下载
wget -P /app/cargo/install https://artifacts.elastic.co/downloads/logstash/logstash-7.2.0.tar.gz
# 解压
tar -zxvf /app/cargo/install/logstash-7.2.0.tar.gz -C /app/cargo
```

- 配置
新建配置文件 config/logstash-sample.conf，内容如下
```
input {
    tcp {
        port => 4560
        codec => json_lines
    }
}
output{
  elasticsearch {
     hosts => ["localhost:9200"]
     index => "%{[appName]}-%{+YYYY.MM.dd}" #用一个项目名称来做索引
  }
  stdout { codec => rubydebug }
}
```
port => 4560是logstash接收数据的端口

codec => json_lines是一个json解析器，接收json的数据，通过bin/logstash-plugin install logstash-codec-json_lines安装插件

output 指向elasticsearch的地址

stdout会打印收到的消息，调试用

- 启动
```
/app/cargo/logstash-7.2.0/bin/logstash -f /app/cargo/logstash-7.2.0/config/logstash-sample.conf
```

## Kibana

Kibana提供了强大而美观的数据可视化，利用Elasticsearch 的RESTful API来实现其强大的搜索能力，将结果显示位各种震撼的图形提供给最终的用户

- 安装
```
# 下载
wget -P /app/cargo/install https://artifacts.elastic.co/downloads/kibana/kibana-7.2.0-linux-x86_64.tar.gz
# 解压
tar -zxvf /app/cargo/install/kibana-7.2.0-linux-x86_64.tar.gz -C /app/cargo
# 启动
/app/cargo/kibana-7.2.0-linux-x86_64/bin/kibana
```
启动成功后，浏览器访问：http://localhost:5601

如果启动时提示glibc版本过低，则升级glibc
```
strings /lib64/libc.so.6 | grep GLIBC
wget -P /app/cargo/install http://ftp.gnu.org/gnu/glibc/glibc-2.14.tar.gz
wget -P /app/cargo/install http://ftp.gnu.org/gnu/glibc/glibc-ports-2.14.tar.gz
tar -zxvf /app/cargo/install/glibc-2.14.tar.gz -C /app/cargo
tar -zxvf /app/cargo/install/glibc-ports-2.14.tar.gz -C /app/cargo
mv /app/cargo/glibc-ports-2.14 /app/cargo/glibc-2.14/ports
mkdir /app/cargo/glibc-2.14/build
cd /app/cargo/glibc-2.14/build
sudo ../configure  --prefix=/usr --disable-profile --enable-add-ons --with-headers=/usr/include --with-binutils=/usr/bin
sudo make & make install

wget -P /app/cargo/install http://ftp.gnu.org/gnu/glibc/glibc-2.17.tar.gz
tar -zxvf /app/cargo/install/glibc-2.17.tar.gz -C /app/cargo
mkdir /app/cargo/glibc-2.17/build
cd /app/cargo/glibc-2.17/build
sudo ../configure  --prefix=/usr --disable-profile --enable-add-ons --with-headers=/usr/include --with-binutils=/usr/bin
sudo make & make install
```

- springboot项目中集成ELK
引入依赖net.logstash.logback:logstash-logback-encoder，然后在logback-spring.xml中增加一个logstash的appender
```
<appender name="LOGSTASH" class="net.logstash.logback.appender.LogstashTcpSocketAppender">
    <destination>localhost:4560</destination>
    <encoder charset="UTF-8" class="net.logstash.logback.encoder.LogstashEncoder" />
</appender>
```




