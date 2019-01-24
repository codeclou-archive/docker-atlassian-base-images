#
# SINCE CONFLUENCE 6.13 WE USE OFFICAL OPENJDK ALPINE IMAGE
#
FROM openjdk:8u181-alpine3.8

ENV CONFLUENCE_VERSION 6.14.0

#
# INSTALL FONTCONFIG AND FIX LD_LIBRARY_PATH
#
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/jvm/java-1.8-openjdk/lib/amd64/:/usr/lib/:/lib/
RUN apk add --no-cache libgcc \
                       ttf-dejavu \
                       fontconfig \
                       libgcc
#
# TEST FONT CONFIG (there should be no errors)
#
RUN mkdir -p /opt/test-fontconfig
ADD test.ttf /opt/test-fontconfig/
ADD TestFontConfig.java /opt/test-fontconfig/
RUN cd /opt/test-fontconfig/ && \
    javac TestFontConfig.java && \
    java -Dsun.java2d.debugfonts=true -cp . TestFontConfig

RUN addgroup -g 10777 worker && \
    adduser -h /work -H -D -G worker -u 10777 worker && \
    mkdir -p /work && \
    mkdir -p /work-private && \
    mkdir /confluence && mkdir /confluence-home && mkdir /confluence-shared-home && \
    chown -R worker:worker /work/ && \
    chown -R worker:worker /work-private/ && \
    apk add --no-cache \
            bash \
            musl-utils \
            curl \
            tar \
            postgresql \
            postgresql-client \
            python \
            py-pip && \
            pip install shinto-cli && \
    curl -jkSL -o /opt/confluence.tar.gz \
         https://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-${CONFLUENCE_VERSION}.tar.gz  && \
    tar zxf /opt/confluence.tar.gz -C /confluence && \
    cd /confluence && \
    ln -s atlassian-confluence-${CONFLUENCE_VERSION} atlassian-confluence-latest && \
    rm /opt/confluence.tar.gz && \
    chown -R worker:worker /confluence && \
    chown -R worker:worker /confluence-home/ && \
    chown -R worker:worker /confluence-shared-home && \
    echo -e "\nconfluence.home=/confluence-home/" >> /confluence/atlassian-confluence-latest/confluence/WEB-INF/classes/confluence-init.properties
