## 1. [Jenkins](https://jenkins.io/)
 - 安装JDK（略）
 - 安装Tomcat（略）
 - 安装Jenkins
 ```
 wget -P /app/cargo/install mirrors.jenkins.io/war/latest/jenkins.war
 cp /app/cargo/install/jenkins.war /app/cargo/apache-tomcat-9.0.6/webapps/
 ```
 - 配置Jenkins
 访问http://172.21.118.62:8080/jenkins/，根据提示操作。
 如果能访问外网但无法在线安装插件，可以进入Jenkins=>插件管理=>高级将升级站点由https改成http
 若无法访问网络则通过Jenkins=>插件管理=>高级离线上传，插件可以在http://updates.jenkins-ci.org/download/plugins/下载

**常用插件**


