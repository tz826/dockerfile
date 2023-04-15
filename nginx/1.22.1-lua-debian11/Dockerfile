FROM debian:11

COPY sources.list-zkd /etc/apt/sources.list

RUN set -eux; \
            \
        apt-get update; \
            \
        apt-get install -y wget procps gcc g++ make perl \
            libpcre3-dev libssl-dev zlib1g-dev libxml2-dev libxslt1-dev; \
            \
        mkdir -p /opt/src; \
        cd /opt/src; \
        # 下载并解压 nginx 源码
        wget -c 'http://nginx.org/download/nginx-1.22.1.tar.gz' -O 'nginx-1.22.1.tar.gz'; \
        tar -xvf nginx-*; \
        # 下载并解压 ngx_devel_kit 模块
        wget -c 'https://github.com/vision5/ngx_devel_kit/archive/refs/tags/v0.3.1.tar.gz' -O 'ngx_devel_kit-v0.3.1.tar.gz'; \
        tar -xvf ngx_devel_kit-*; \
        # 下载并解压 lua-nginx-module 模块
        wget -c 'https://github.com/openresty/lua-nginx-module/archive/refs/tags/v0.10.21.tar.gz' -O 'lua-nginx-module-v0.10.21.tar.gz'; \
        tar -xvf lua-nginx-module-*; \
        # 下载并解压 lua 核心模块 lua 脚本包 ( 实现免安装 lua 可以让 lua_nginx-module 模块调用 lua, 该核心模块包中的 lua 版本为 5.1 )
        wget -c 'https://github.com/openresty/lua-resty-core/archive/refs/tags/v0.1.23.tar.gz' -O 'lua-resty-core-v0.1.23.tar.gz'; \
        tar -xvf lua-resty-core-* -C /usr/local; \
        # 下载并解压 lua 缓存模块 lua 脚本包 ( 将 lua 变量缓存在 lua vm 中 )
        wget -c 'https://github.com/openresty/lua-resty-lrucache/archive/refs/tags/v0.13.tar.gz' -O 'lua-resty-lrucache-v0.13.tar.gz'; \
        tar -xvf lua-resty-lrucache-* -C /usr/local; \
        # 下载并解压 lua redis 模块包 ( 用于 lua 操作 redis 的脚本库，可选 )
        wget -c 'https://github.com/openresty/lua-resty-redis/archive/refs/tags/v0.29.tar.gz' -O 'lua-resty-redis-v0.29.tar.gz'; \
        tar -xvf lua-resty-redis-* -C /usr/local; \
            \
        # 安装 luajit2
        wget -c 'https://github.com/openresty/luajit2/archive/refs/tags/v2.1-20230119.tar.gz' -O 'luajit2-v2.1-20230119.tar.gz'; \
        tar -xvf luajit2-*; \
        cd luajit* ; \
        make PREFIX=/usr/local/luajit && make install PREFIX=/usr/local/luajit; \
        ln -s /usr/local/luajit/bin/luajit /usr/local/bin/luajit; \
        # 链接库设置
        echo "/usr/local/luajit/lib" >> /etc/ld.so.conf.d/libc.conf; \
        ldconfig; \
        # 临时生效
        export LUAJIT_LIB=/usr/local/luajit/lib; \
        export LUAJIT_INC=/usr/local/luajit/include/luajit-2.1; \
            \
        # 编译安装 nginx
        cd /opt/src/nginx-*; \
        ./configure \
            --prefix=/usr/local/nginx \
            --modules-path=/usr/local/nginx/modules \
            --conf-path=/etc/nginx/nginx.conf \
            --error-log-path=/var/log/nginx/error.log \
            --http-log-path=/var/log/nginx/access.log \
            --pid-path=/var/run/nginx.pid \
            --lock-path=/var/run/nginx.lock \
            --user=nginx \
            --group=nginx \
            --with-compat \
            --with-threads \
            --with-http_addition_module \
            --with-http_auth_request_module \
            --with-http_dav_module \
            --with-http_flv_module \
            --with-http_gunzip_module \
            --with-http_gzip_static_module \
            --with-http_mp4_module \
            --with-pcre \
            --with-http_random_index_module \
            --with-http_realip_module \
            --with-http_secure_link_module \
            --with-http_slice_module \
            --with-http_ssl_module \
            --with-http_stub_status_module \
            --with-http_sub_module \
            --with-http_v2_module \
            --with-mail \
            --with-mail_ssl_module \
            --with-stream \
            --with-stream_realip_module \
            --with-stream_ssl_module \
            --with-stream_ssl_preread_module \
            --with-http_addition_module --with-http_random_index_module \
            --with-compat --with-file-aio \
            --with-cc-opt='-Os -fomit-frame-pointer -g'  \
            --with-ld-opt='-Wl,-rpath,/usr/local/luajit/lib,--as-needed,-O1,--sort-common' \
            --add-module=/opt/src/ngx_devel_kit-0.3.1 \
            --add-module=/opt/src/lua-nginx-module-0.10.21; \
        make -j $(nproc); \
        make install -j $(nproc); \
        ln -svf /usr/local/nginx/sbin/nginx /usr/sbin; \
        ln -svf /dev/stdout /var/log/nginx/access.log; \
        ln -svf /dev/stderr /var/log/nginx/error.log; \
            \
        groupadd --system --gid 999 nginx; \
        adduser --system --shell /usr/sbin/nologin --no-create-home --uid 999 --gid 999 --disabled-login nginx; \
            \
        apt-get -y remove wget vim procps gcc g++ make perl \
            libpcre3-dev libssl-dev zlib1g-dev libxml2-dev libxslt1-dev; \
        apt-get -y autoremove; \
        apt-get clean; \
        rm -rf /opt/src; \
        rm -rf /var/lib/apt/lists/*;

COPY nginx.conf /etc/nginx/nginx.conf
COPY conf.d /etc/nginx/conf.d

EXPOSE 80 443

CMD [ "nginx", "-g", "daemon off;" ]


###
# 构建命令
#     docker build --network=host -f Dockerfile -t noi1031/nginx:1.22.1-lua-debian11 ./
###
# 测试命令
#     docker run -it --rm -p 80:80 noi1031/nginx:1.22.1-lua-debian11
#     # 访问 /lua 测试 lua 脚本是否可用
###
