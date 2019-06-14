
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

```elk
# 清理: method:GET and path:version
GET /logstash/_delete_by_query
{
  "query": {
    "bool": {
      "filter": [
        {
          "bool": {
            "filter": [
              {
                "bool": {
                  "should": [
                    {
                      "match": {
                        "path": "version"
                      }
                    }
                  ],
                  "minimum_should_match": 1
                }
              },
              {
                "bool": {
                  "should": [
                    {
                      "match": {
                        "method": "GET"
                      }
                    }
                  ],
                  "minimum_should_match": 1
                }
              }
            ]
          }
        }
      ]
    }
  }
}

# 清理 rpc.call.keyword:Jinmuhealth.GetVersion
GET /logstash/_delete_by_query
{
  "query": {
    "bool": {
      "filter": [
        {
          "bool": {
            "should": [
              {
                "match": {
                  "rpc.call.keyword": "Jinmuhealth.GetVersion"
                }
              }
            ],
            "minimum_should_match": 1
          }
        }
      ]
    }
  }
}
```

