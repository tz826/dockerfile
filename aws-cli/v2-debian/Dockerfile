FROM debian:11

COPY sources.list-zkd /etc/apt/sources.list

RUN set -eux; \
        \
    apt-get update; \
    apt-get install -y curl zip less; \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"; \
    unzip awscliv2.zip; \
    ./aws/install; \
    rm -rf aws*;

###
# 构建命令
#   docker build -t noi1031/aws-cli:v2-debian ./
###
# 运行测试
#   docker run -it --rm -v ~/.aws:/root/.aws --entrypoint=/bin/bash noi1031/aws-cli:v2-debian
#   执行测试命令 : aws sts get-caller-identity
###
