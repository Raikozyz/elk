
# 清理 ELB 心跳请求数据

## Logstash Pipeline 过滤

```ruby
filter {
  if [rpc.call] =~ "^\w+\.GetVersion$" {
    drop {}
  }
}
```



## 手动清理

https://dev-elk.jinmuhealth.com:6996/app/kibana#/dev_tools/console

参见 [clear_logstash_docs.es](clear_logstash_docs.es) 文件
