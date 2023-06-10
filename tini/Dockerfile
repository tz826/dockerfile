FROM debian:11

ENV TINI_VERSION v0.19.0

ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini

RUN set -eux; \
        \
    chmod +x /usr/bin/tini

# 通过 tini 启动 CMD 中的命令
# 通过 tini 启动可以使 tini 的 pid 为 1，其余命令生成的进程由 tini 进行管理，在 tini 收到容器
#   管理工具的 SIGTERM(15) 信号时可以将信号转发给所有由 tini 管理的子进程，实现优雅关闭
ENTRYPOINT [ "tini", "--" ]

# CMD 中命令生成的进程由 tini 管理 ( 如果不使用 tini 则 /bin/bash 会变为 pid 1 进程 ( 使用 ps 时不一定能发现是由 bin/bash 启动 )，在收到
#   容器管理工具发送的停止信号时 /bin/bash 不会做任何操作 ( 也不会将停止信号转发给子进程 )，
#   实际使用的进程为 tail -f /dev/null ( /bin/bash 的子进程 )，会导致容器管理工具等待超时后使
#   用 SIGKILL(9) 强制杀死容器的 pid 1 进程， /bin/bash 被杀死之后子进程 tail 也会结束)
# CMD [ "/bin/bash", "-c", "tail -f /dev/null" ]
