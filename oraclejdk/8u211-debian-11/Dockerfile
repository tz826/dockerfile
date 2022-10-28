FROM docker.io/noi1031/gosu:1.14-debian-11

ADD jdk*.tar.gz /usr/local

ENV JDK_VERSION "OracleJDK-8u211"
ENV JAVA_HOME "/usr/local/jdk/"
ENV CLASSPATH "${JAVA_HOME}/lib/"

RUN set -eux; \
            \
        ln -sv /usr/local/jdk* /usr/local/jdk; \
        ln -sv /usr/local/jdk/bin/* /usr/bin/; \
            \
        groupadd --system --gid 999 java; \
        adduser --system --shell /usr/sbin/nologin --no-create-home --uid 999 --gid 999 --disabled-login java

ENTRYPOINT [ "gosu", "java:java", "java" ]

CMD [ "-version" ]
