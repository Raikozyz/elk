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
