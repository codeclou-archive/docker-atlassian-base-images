FROM codeclou/docker-oracle-jdk:8u131

ENV CONFLUENCE_VERSION 6.3.1

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
