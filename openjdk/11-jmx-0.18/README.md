<div align="center"><h2>镜像使用方法</h2></div>

[TOC]

***

# jmx 镜像使用方法

镜像内部带有 jmx_prometheus_javaagent-0.18.0.jar 包，可以实现通过 jvm 进程内启动 jmx javaagent 监控 jvm 及系统指标，需要以该镜像为基础镜像对 jar 包进行打包

作为基础镜像打包 jar 包示例

## dockerfile

镜像中已经定义了 `ENV JAVA_AGENT -javaagent:/jmx/jmx_prometheus_javaagent.jar=9901:/jmx/config.yaml` 环境变量，可以在自定义 dockerfile 中直接使用无需再次定义

```dockerfile
FROM noi1031/openjdk:11-jmx-0.18

COPY springboot-test.jar /app/
COPY application.yaml /app/

ENV JAVA_OPTS -Xms100m -Xmx100m
# JAVA_AGENT 可以无需再次定义，因为在基础镜像 noi1031/openjdk:11-jmx 中已经定义
ENV JAVA_AGENT -javaagent:/jmx/jmx_prometheus_javaagent.jar=9901:/jmx/config.yaml
ENV JAVA_APP -jar springboot-test.jar --spring.config.location=application.yaml

EXPOSE 9901 8081

WORKDIR /app

ENTRYPOINT [ "sh", "-c", "java ${JAVA_OPTS} ${JAVA_AGENT} ${JAVA_APP}" ]
```

> `-javaagent:/jmx/jmx_prometheus_javaagent.jar=9901:/jmx/config.yaml` 指定启动 jar 包同时启动 javaagent ，agent 即为 `jmx_prometheus_javaagent.jar` 可以让其收集到 jvm 及系统进程的指标，暴露给 prometheus 进行获取。
>
> jmx_prometheus_javaagent 暴露的 metrics 端口为 9901，metrics 路径为 /
>
> 其余部分正常添加启动 jar 包的参数即可

## 构建并运行镜像

```shell
docker build --network=host -t springboot-test:v1 ./

docker run -d --name=spb-test --network=host springboot-test:v1
```

检查端口

```shell
netstat -tlnp |grep java
tcp6       0      0 :::9901                 :::*                    LISTEN      3052654/java        
tcp6       0      0 :::8081                 :::*                    LISTEN      3052654/java
```

访问 jmx 暴露的 metrics 测试

```shell
curl -s 127.0.0.1:9901 |grep heap
jvm_memory_bytes_used{area="heap",} 2.4497664E7
jvm_memory_bytes_used{area="nonheap",} 5.158892E7
jvm_memory_bytes_committed{area="heap",} 1.048576E8
jvm_memory_bytes_committed{area="nonheap",} 5.5820288E7
jvm_memory_bytes_max{area="heap",} 1.048576E8  ## 最大堆内存 100M 监控成功
jvm_memory_bytes_max{area="nonheap",} -1.0
jvm_memory_bytes_init{area="heap",} 1.048576E8
jvm_memory_bytes_init{area="nonheap",} 7667712.0
```

删除测试容器

```shell
docker rm -f spb-test
```









