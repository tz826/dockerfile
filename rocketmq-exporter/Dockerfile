FROM openjdk:11

COPY *.jar /app/rocketmq-exporter.jar
COPY application.yml /app

ENV NAMESRV 127.0.0.1:9876

EXPOSE 5557

WORKDIR /app

ENTRYPOINT [ "java", "-jar", "rocketmq-exporter.jar", "--spring.config.location=./application.yml" ]

###
# 构建命令 ( 先执行 peoject_build.sh 脚本 )
#     docker build --network=host -t noi1031/rocketmq-exporter:20221109 ./
###
# 临时运行 ( 多个 nameserver 使用 ; 符号分隔, 使用分号必须使用双引号括起 )
#     docker run -it --rm -e NAMESRV=192.168.8.128:30391 noi1031/rocketmq-exporter:20221109
###
