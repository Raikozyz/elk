#!/usr/bin/env bash
set -e
set -u
set -o pipefail

$(aws ecr get-login --no-include-email --region cn-north-1)

docker tag docker-elk_elasticsearch:latest 949191617935.dkr.ecr.cn-north-1.amazonaws.com.cn/jm-elk/elasticsearch:latest
docker tag docker-elk_logstash:latest 949191617935.dkr.ecr.cn-north-1.amazonaws.com.cn/jm-elk/logstash:latest
docker tag docker-elk_kibana:latest 949191617935.dkr.ecr.cn-north-1.amazonaws.com.cn/jm-elk/kibana:latest
docker tag docker-elk_logspout:latest 949191617935.dkr.ecr.cn-north-1.amazonaws.com.cn/jm-elk/logspout:latest


docker push 949191617935.dkr.ecr.cn-north-1.amazonaws.com.cn/jm-elk/elasticsearch:latest
docker push 949191617935.dkr.ecr.cn-north-1.amazonaws.com.cn/jm-elk/logstash:latest
docker push 949191617935.dkr.ecr.cn-north-1.amazonaws.com.cn/jm-elk/kibana:latest
docker push 949191617935.dkr.ecr.cn-north-1.amazonaws.com.cn/jm-elk/logspout:latest
