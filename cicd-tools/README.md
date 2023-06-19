## cicd-tools -- 容器环境下常用 cicd 工具镜像

该镜像中包含 k8s、容器环境下 cicd 的常用工具套件 ( docker、podman、kubectl 等 )

:warning: `kubectl`、`docker|podman` 是所有 tag 镜像中的默认工具，基础容器工具 ( `docker|podman` ) 根据镜像 tag 区分，tag 中出现 podman 的其基础容器工具即为 podman，如果 tag 中没有出现 podman 的其基础容器工具为 docker 

Dockerfile 地址 : https://github.com/noise131/dockerfile/tree/main/cicd-tools

## 镜像说明

镜像 tag 说明

- `*-podman*` : 表示该镜像中的基础容器工具为 podman，如果没有 podman 标志则默认为 docker
- `*-aws*` : 该镜像中包含基础工具及其 tag 包含工具的前提下包含 `aws-cli` 工具

镜像版本说明

- `v1` : 工具版本如下 `podman_v3.4.4`、`kubectl_v1.26.3`、`aws-cli_v2`、`docker_20.10.x` ( 仅列出可能存在的工具版本，具体工具是否存在于镜像根据 tag 决定 )

## 镜像使用示例

- podman 镜像

```shell
podman run -it --rm \
  -v /var/run/podman/podman.sock:/var/run/podman/podman.sock \
  -v ~/.kube:/root/.kube \
  noi1031/cicd-tools:v1-podman /bin/bash
```

> 容器中的 podman 仅为客户端，必须挂载宿主机的 `podman.sock` 才能正常使用，宿主机上必须正确安装 podman 工具
>
> 安装文档 : [Podman Installation | Podman](https://podman.io/docs/installation#linux-distributions)

- aws 镜像

```shell
podman run -it --rm \
  -v /var/run/podman/podman.sock:/var/run/podman/podman.sock \
  -v ~/.kube:/root/.kube \
  -v ~/.aws:/root/.aws \
  noi1031/cicd-tools:v1-podman-aws /bin/bash
```

> 执行 aws 命令测试
>
> ```shell
> root@493f0978666a:/# aws sts get-caller-identity
> {
>     "UserId": "xxxxxxxx",
>     "Account": "xxxxxxxx",
>     "Arn": "arn:aws:iam::xxxxxxxx:user/xxxx"
> }
> ```

