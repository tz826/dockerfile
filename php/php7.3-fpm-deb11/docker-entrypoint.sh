#!/bin/bash

set -ex
#cd "$(dirname $0)"

PHP_CONFIG_FILE="/etc/php/$PHP_VER/cli/php.ini /etc/php/$PHP_VER/fpm/php.ini"

# 短标签支持, 默认值 Off
if [ -n "$SHORT_OPEN_TAG" ]; then
    sed -i -r \
        -e "/^short_open_tag\s*=/s/^.*$/; &/g" \
        -e "/^\[PHP\]/a short_open_tag = $SHORT_OPEN_TAG" \
        $PHP_CONFIG_FILE
fi

# 脚本最大运行时间, 默认值 30
if [ -n "$MAX_EXECUTION_TIME" ]; then
    sed -i -r \
        -e "/^max_execution_time\s*=/s/^.*$/; &/g" \
        -e "/^\[PHP\]/a max_execution_time = $MAX_EXECUTION_TIME" \
        $PHP_CONFIG_FILE
fi

# 最大输入时间, 默认值 60
if [ -n "$MAX_INPUT_TIME" ]; then
    sed -i -r \
        -e "/^max_input_time\s*=/s/^.*$/; &/g" \
        -e "/^\[PHP\]/a max_input_time = $MAX_INPUT_TIME" \
        $PHP_CONFIG_FILE
fi

# 脚本内存限制, 默认值 128M
if [ -n "$MEMORY_LIMIT" ]; then
    sed -i -r \
        -e "/^memory_limit\s*=/s/^.*$/; &/g" \
        -e "/^\[PHP\]/a memory_limit = $MEMORY_LIMIT" \
        $PHP_CONFIG_FILE
fi

# post 的数据最大大小, 默认值 8M
if [ -n "$POST_MAX_SIZE" ]; then
    sed -i -r \
        -e "/^post_max_size\s*=/s/^.*$/; &/g" \
        -e "/^\[PHP\]/a post_max_size = $POST_MAX_SIZE" \
        $PHP_CONFIG_FILE
fi

# 是否允许文件上传, 默认值 On
if [ -n "$FILE_UPLOADS" ]; then
    sed -i -r \
        -e "/^file_uploads\s*=/s/^.*$/; &/g" \
        -e "/^\[PHP\]/a file_uploads = $FILE_UPLOADS" \
        $PHP_CONFIG_FILE
fi

# 允许上传文件的最大尺寸, 默认值 2M
if [ -n "$UPLOAD_MAX_FILESIZE" ]; then
    sed -i -r \
        -e "/^upload_max_filesize\s*=/s/^.*$/; &/g" \
        -e "/^\[PHP\]/a upload_max_filesize = $UPLOAD_MAX_FILESIZE" \
        $PHP_CONFIG_FILE
fi

# 允许同时上传文件的个数, 默认值 20
if [ -n "$MAX_FILE_UPLOADS" ]; then
    sed -i -r \
        -e "/^max_file_uploads\s*=/s/^.*$/; &/g" \
        -e "/^\[PHP\]/a max_file_uploads = $MAX_FILE_UPLOADS" \
        $PHP_CONFIG_FILE
fi

# socket 超时时间, 默认值 60
if [ -n "$DEFAULT_SOCKET_TIMEOUT" ]; then
    sed -i -r \
        -e "/^default_socket_timeout\s*=/s/^.*$/; &/g" \
        -e "/^\[PHP\]/a default_socket_timeout = $DEFAULT_SOCKET_TIMEOUT" \
        $PHP_CONFIG_FILE
fi

# 记录的错误日志级别, 默认值 E_ALL & ~E_DEPRECATED & ~E_STRICT
if [ -n "$ERROR_REPORTING" ]; then
    sed -i -r \
        -e "/^error_reporting\s*=/s/^.*$/; &/g" \
        -e "/^\[PHP\]/a error_reporting = $ERROR_REPORTING" \
        $PHP_CONFIG_FILE
fi

# 是否输出详细错误信息, 默认值 Off
if [ -n "$DISPLAY_ERRORS" ]; then
    sed -i -r \
        -e "/^display_errors\s*=/s/^.*$/; &/g" \
        -e "/^\[PHP\]/a display_errors = $DISPLAY_ERRORS" \
        $PHP_CONFIG_FILE
fi

# 是否开启 pathinfo, 默认值 1 (1 为开启，0 为关闭)
if [ -n "$CGI_FIX_PATHINFO" ]; then
    sed -i -r \
        -e "/^cgi\.fix_pathinfo\s*=/s/^.*$/; &/g" \
        -e "/^\[PHP\]/a cgi.fix_pathinfo = $CGI_FIX_PATHINFO" \
        $PHP_CONFIG_FILE
fi

# 设置 php 时区, 默认值 UTC (PRC 或 Asia/Shanghai 为中国时区)
if [ -n "$DATE_TIMEZONE" ]; then
    sed -i -r \
        -e "/^date\.timezone\s*=/s/^.*$/; &/g" \
        -e "/^\[Date\]/a date.timezone = $DATE_TIMEZONE" \
        $PHP_CONFIG_FILE
fi

exec "$@"
