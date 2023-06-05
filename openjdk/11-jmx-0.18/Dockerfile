FROM openjdk:11

COPY jmx_prometheus_javaagent-0.18.0.jar /jmx/jmx_prometheus_javaagent.jar
COPY config.yaml /jmx/

ENV JAVA_AGENT -javaagent:/jmx/jmx_prometheus_javaagent.jar=9901:/jmx/config.yaml

EXPOSE 9901

###
# 构建命令
#   docker build --network=host -t noi1031/openjdk:11-jmx-0.18 ./
###
