#!/bin/bash

set -eux
cd "$(dirname $0)"

GIT_URL="https://github.com/apache/rocketmq-exporter.git"
PROJECT_DIR="rocketmq-exporter"
BUILD_IMAGE="maven:3.8.6-openjdk-11"

rm -rf ./src
mkdir -p ./src
cd ./src

git clone "$GIT_URL"

docker run --rm \
    --network=host \
    --workdir=/$PROJECT_DIR \
    -v /data/maven_localrepo:/root/.m2 \
    -v $(pwd)/$PROJECT_DIR:/$PROJECT_DIR \
    --entrypoint=/bin/bash \
    "$BUILD_IMAGE" \
    -c "mvn clean package -Dmaven.test.skip=true"

cd ../

rm -rf *.jar *.yml

cp -a ./src/"$PROJECT_DIR"/target/*-exec.jar ./
cp -a ./src/"$PROJECT_DIR"/src/main/resources/application.yml ./

sed -r -i.bak \
    -e "s/127.0.0.1:9876/\${NAMESRV:127.0.0.1:9876}/g" \
    ./application.yml
