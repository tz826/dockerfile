#!/bin/sh

set -e
set -o pipefail

CONFIG_PATH='/root/.config/rclone/rclone.conf'

error_log() {
    echo "Env variable ${1} undefined" >&2
}

[ "$(id -u)" != 0 ] && echo "User not is root !" && exit 1
[ -z "${S3_ACCESS_KEY}" ] && error_log \"S3_ACCESS_KEY\" && exit 1
[ -z "${S3_SECRET_KEY}" ] && error_log \"S3_SECRET_KEY\" && exit 1
[ -z "${S3_ENDPOINT}" ] && error_log \"S3_ENDPOINT\" && exit 1
[ -z "${S3_BUCKET}" ] && error_log \"S3_BUCKET\" && exit 1

export S3_DIR="${S3_DIR:-/s3}"
export S3_REGION="${S3_REGION:-Unknown}"
export LOG_LEVEL="${LOG_LEVEL:-1}"

eval "cat <<EOF
$("<${CONFIG_PATH}")
EOF" >"${CONFIG_PATH}"

echo 
echo "----------S3 Storage Connect Info----------"
echo "S3_ACCESS_KEY: ${S3_ACCESS_KEY}"
echo "S3_SECRET_KEY: ${S3_SECRET_KEY}"
echo "S3_ENDPOINT: ${S3_ENDPOINT}"
echo "S3_REGION: ${S3_REGION}"
echo
echo "----------S3 Mount Info----------"
echo "S3_BUCKET: ${S3_BUCKET}"
echo "S3_DIR: ${S3_DIR}"
echo

echo "${S3_ACCESS_KEY}:${S3_SECRET_KEY}" >/etc/passwd-s3fs
chmod 600 /etc/passwd-s3fs

mkdir -p "${S3_DIR}"

echo "Mounting......"
# s3fs -o allow_other -o use_path_request_style -o url="${S3_ENDPOINT}" -o bucket="${S3_BUCKET}" -o endpoint="${S3_REGION}" "${S3_DIR}" && \
#     echo "Mount Result : S3 ${S3_BUCKET} Mount Success !" && \
#     echo "Mount Info : $(mount |grep "${S3_DIR}")"

if [ "${LOG_LEVEL}" -ge 2 ]; then
    rclone -vv mount minio-test:/test-bucket /minio-mount/ --allow-other --allow-non-empty --no-check-certificate --vfs-cache-mode=full
else
    rclone -v mount minio-test:/test-bucket /minio-mount/ --allow-other --allow-non-empty --no-check-certificate --vfs-cache-mode=full
fi

