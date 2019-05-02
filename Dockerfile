FROM adoptopenjdk/openjdk8:x86_64-ubuntu-jdk8u202-b08


ENV JIRA_VERSION 8.1.0
ENV DEBIAN_FRONTEND=noninteractive

#
# INSTALL FONTCONFIG AND FIX LD_LIBRARY_PATH
#
RUN apt-get update && apt-get -y install \
                       ttf-dejavu \
                       libfontconfig1 

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
RUN addgroup --gid 10777 worker && \
    adduser --home /work  --gid 10777 --uid 10777 --disabled-password --gecos "" worker && \
    mkdir -p /work && \
    mkdir -p /work-private && \
    mkdir /jira && mkdir /jira-home && mkdir /jira-shared-home && \
    chown -R worker:worker /work/ && \
    chown -R worker:worker /work-private/ && \
    apt-get -y install \
            bash \
            curl \
            tar \
            postgresql \
            postgresql-client \
            python \
            python-pip && \
            pip install shinto-cli && \
    curl -jkSL -o /opt/jira.tar.gz \
         https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-${JIRA_VERSION}.tar.gz  && \
    tar zxf /opt/jira.tar.gz -C /jira && \
    cd /jira && \
    ln -s atlassian-jira-software-${JIRA_VERSION}-standalone atlassian-jira-software-latest-standalone && \
    rm /opt/jira.tar.gz && \
    chown -R worker:worker /jira && \
    chown -R worker:worker /jira-home/ && \
    chown -R worker:worker /jira-shared-home && \
    chown -R worker:worker /opt/java/openjdk/


