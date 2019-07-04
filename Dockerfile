#
# Switch to ubuntu, since alpine image has fontConfig errors
#
## Still not java 11 compatible! FROM adoptopenjdk/openjdk11:x86_64-ubuntu-jdk-11.0.3.7
FROM adoptopenjdk/openjdk8:x86_64-ubuntu-jdk8u212-b04

ENV CONFLUENCE_VERSION 7.0.1-m103
ENV DEBIAN_FRONTEND noninteractive


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

RUN addgroup --gid 10777 worker && \
    adduser --home /work  --gid 10777 --uid 10777 --disabled-password --gecos "" worker && \
    mkdir -p /work && \
    mkdir -p /work-private && \
    mkdir /confluence && mkdir /confluence-home && mkdir /confluence-shared-home && \
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
