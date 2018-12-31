#
# https://github.com/AdoptOpenJDK/openjdk-docker
# https://hub.docker.com/r/adoptopenjdk/openjdk11/tags
# https://hub.docker.com/r/adoptopenjdk/openjdk8/tags
#
## LATER: FROM adoptopenjdk/openjdk11:jdk-11.0.1.13-alpine
FROM adoptopenjdk/openjdk8:jdk8u192-b12-alpine

ENV JIRA_DOWNLOAD_VERSION   8.0.0-BETA
ENV JIRA_FILESYSTEM_VERSION 8.0.0-m0030
#
# ESSENTIALS
#
RUN apk add --no-cache \
            bash \
            curl \
            tar

#
# INSTALL FONTCONFIG AND FIX LD_LIBRARY_PATH (https://github.com/AdoptOpenJDK/openjdk-docker/issues/75)
#
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/
RUN apk add --no-cache libgcc \
                       ttf-dejavu \
                       fontconfig \
                       libgcc && \
    ln -s /lib/libc.musl-x86_64.so.1 /usr/lib/libc.musl-x86_64.so.1


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
            python \
            py-pip && \
            pip install shinto-cli && \
    curl -jkSL -o /opt/jira.tar.gz \
         https://product-downloads.atlassian.com/software/jira/downloads/atlassian-jira-software-${JIRA_DOWNLOAD_VERSION}.tar.gz && \
    tar zxf /opt/jira.tar.gz -C /jira && \
    cd /jira && \
    ln -s atlassian-jira-software-${JIRA_FILESYSTEM_VERSION}-standalone atlassian-jira-software-latest-standalone && \
    rm /opt/jira.tar.gz && \
    chown -R worker:worker /jira && \
    chown -R worker:worker /jira-home/ && \
    chown -R worker:worker /jira-shared-home