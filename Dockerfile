#
# SINCE JIRA 7.13 WE USE OFFICAL OPENJDK ALPINE IMAGE
#
FROM openjdk:8u181-alpine3.8

ENV JIRA_VERSION 8.0.1

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

#
# INSTALL
#
RUN addgroup -g 10777 worker && \
    adduser -h /work -H -D -G worker -u 10777 worker && \
    mkdir -p /work && \
    mkdir -p /work-private && \
    mkdir /jira && mkdir /jira-home && mkdir /jira-shared-home && \
    chown -R worker:worker /work/ && \
    chown -R worker:worker /work-private/ && \
    apk add --no-cache \
            bash \
            curl \
            tar \
            python \
            py-pip && \
            pip install shinto-cli && \
    curl -jkSL -o /opt/jira.tar.gz \
         https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-${JIRA_VERSION}.tar.gz  && \
    tar zxf /opt/jira.tar.gz -C /jira && \
    cd /jira && \
    ln -s atlassian-jira-software-${JIRA_VERSION}-standalone atlassian-jira-software-latest-standalone && \
    rm /opt/jira.tar.gz && \
    chown -R worker:worker /jira && \
    chown -R worker:worker /jira-home/ && \
    chown -R worker:worker /jira-shared-home

