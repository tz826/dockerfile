新增 git 程序

构建命令

```shell
docker build --network=host -f Dockerfile -t noi1031/k8s-cicd-tools:v2 ./
```

测试运行命令

```shell
docker run -it --rm --network=host --entrypoint=/bin/bash noi1031/k8s-cicd-tools:v2
```

> 进入容器后可进行各命令测试
