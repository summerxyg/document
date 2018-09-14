- 安装node.js
```
// 下载 & 解压 & 编译
wget -P /opt/install https://nodejs.org/dist/v8.11.3/node-v8.11.3-linux-s390x.tar.xz
tar -zxvf /opt/install/node-v8.11.3-linux-s390x.tar.xz -C /opt/app
// 建立软链接
ln -s /opt/app/nodejs/bin/npm /usr/local/bin/
ln -s /opt/app/nodejs/bin/node /usr/local/bin/
// 检查安装是否成功
node -v
```
- 安装cnmp
```
npm install -g cnpm --registry=http://registry.npm.taobao.org
// 检查安装是否成功
cnmp -v
```
- 安装vue
```
cnpm install -g vue-cli
```

- 建立一个vue项目
```
// 创建一个基于webpack的vue项目
vue init webpack vue-demo
// 安装依赖
ce vue-demo
npm install
npm run dev
```
- 访问http:localhost:8080检查是否成功

- 发布上线
* 打包
* 将dist目录部署到apache或nginx上
```
npm run build
```


