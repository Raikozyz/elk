# 部署手册

### 部署清单

1. **ELK节点**：`jm-elk`
2. **logspout日志采集器：**`logspout`

------

### 部署ELK - 单节点Stack

**文件夹：**`jm-elk`

> 以下步骤在此文件夹中操作完成

#### Step 1: 上传 Docker Compose 配置

将`jm-elk`上传到目标服务器。

如果目标服务器是 Linux 操作系统，需要执行以下操作调整容器卷授权，其它系统可以忽略：

```sh
# Linux only
mkdir -p data/elasticsearch
chown -R 1000:1000 data/elasticsearch
```

#### Step 2: 启动 Docker Compose

```sh
# 拉取最新镜像(需要 docker login)
docker-compose pull
# 后台启动
docker-compose up -d
```

> 在配置过 AWS CLI 的机器上，执行以下指令可以获取 docker login 信息：
>
> ```sh
> aws ecr get-login --no-include-email --region cn-north-1
> ```

等待一段时间后，查看日志，验证 ELK 是否启动成功

```sh
docker-compose logs -f
```

#### Step 3: 上传 License

1. 打开 **Kibana** 系统，默认端口为 **5601**。假如当前部署服务器的地址为 192.168.10.10，访问 http://192.168.10.10:5601
2. 使用默认用户名和密码登录：
   - 用户名：elastic
   - 密码：changeme
3. 进入 **Management** > **Elasticsearch** > **License Management** 菜单，点击 **Update License** 按钮，上传新的 License 文件。License 文件位于本项目根文件夹下的 [elasticsearch-license.json](../elasticsearch-license.json)

#### Step 4: 重新生成密码，并修改配置文件

1. 执行以下命令，重新生成密码：

  ```sh
  docker-compose exec -T elasticsearch 'bin/elasticsearch-setup-passwords' auto --batch
  ```

  输出类似如下信息：

  ```txt
  Changed password for user apm_system
  PASSWORD apm_system = gXd1wBKXjGs8fFU7mgP9

  Changed password for user kibana
  PASSWORD kibana = qT9UuYj1z2vCGrbEtJNF

  Changed password for user logstash_system
  PASSWORD logstash_system = P1DWEvaUgg9ZnBdQwtSH

  Changed password for user beats_system
  PASSWORD beats_system = WWjp22YrFMWxvzK2xfpM

  Changed password for user remote_monitoring_user
  PASSWORD remote_monitoring_user = xRiHBaaZkFplBTDSkpVl

  Changed password for user elastic
  PASSWORD elastic = OpqSl00BrTg7RPwh8Bnn
  ```

2. 修改 [kibana/config/kibana.yml](jm-elk/kibana/config/kibana.yml) 配置文件，将 `elasticsearch.username`设置为`kibana`，`elasticsearch.password`设置为以上生成的新密码。

   ```yml
   elasticsearch.username: kibana
   elasticsearch.password: 使用生成的密码
   ```

3. 修改 [logstash/config/logstash.yml](jm-elk/logstash/config/logstash.yml) 配置文件，将 `xpack.monitoring.elasticsearch.username`设置为`logstash_system`，`xpack.monitoring.elasticsearch.password`设置为以上生成的新密码。

   ```yml
   xpack.monitoring.enabled: true
   xpack.monitoring.elasticsearch.username: logstash_system
   xpack.monitoring.elasticsearch.password: 使用生成的密码
   ```

4. 修改 [logstash/pipeline/logstash.conf](jm-elk/logstash/pipeline/logstash.conf) 配置文件，修改 `password`部分

   ```conf
   output {
   	elasticsearch {
   		hosts => "elasticsearch:9200"
   		user => elastic
   		password => 使用生成的密码
   	}
   }
   ```

5. 修改完成，重启服务：

  ```sh
  docker-compose restart kibana logstash
  ```

6. 使用新的用户名和密码登录

#### Step 5: 优化 JVM 参数

修改 [docker-compose.yml](jm-elk/docker-compose.yml) 文件，调整 **elasticsearch** 服务的环境变量 `ES_JAVA_OPTS`与**logstash**服务的环境变量`LS_JAVA_OPTS`的值。根据目标服务器内存情况调整，建议大小设定为服务器物理内存的1/4大小。

例如，物理内存有4GB，那么设定值可以为`-Xmx1g -Xms1g`

修改完成需要重启服务

```sh
docker-compose restart
```

------

### 部署logspout日志采集器

**文件夹：**`logspout`

> 以下步骤在此文件夹中操作完成

需要采集日志的目标服务器上需要部署运行 **logspout** 日志采集器

#### Step 1: 上传 Docker Compose 配置

将`logspout`上传到目标服务器。

#### Step 2: 修改配置信息

**配置文件：**`.env`

**配置参数：**

- **ROUTE_URIS：**Logstash 监听地址
- **SHIP_NAME：**机器名称 *(Tip: ship 运输 container)*

修改`.env`隐藏文件，假设 **Logstash** 部署位于 192.168.10.10服务器之上，监听端口为 TCP 5000，那么设定值为 `logstash+tcp://192.168.10.10:5000`。

修改 **SHIP_NAME**，将该值设定为当前机器名称，例如 `gf-dev`。

#### Step 3: 启动 Docker Compose

```sh
# 拉取最新镜像(需要 docker login)
docker-compose pull
# 后台启动
docker-compose up -d
```

> 在配置过 AWS CLI 的机器上，执行以下指令可以获取 docker login 信息：
>
> ```sh
> aws ecr get-login --no-include-email --region cn-north-1
> ```

等待一段时间后，查看日志，验证是否启动成功。

```sh
docker-compose logs -f
```

