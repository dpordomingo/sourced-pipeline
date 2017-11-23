FROM ubuntu:16.04

ENV USER_HOME /root
WORKDIR ${USER_HOME}

ENV PATH $PATH:${USER_HOME}/spark/bin

ENV CONFIG_DBHOST db
ENV CONFIG_BROKER_URL amqp://guest:guest@rabbit:5672/
ENV CONFIG_TEMP_DIR /tmp/borges
ENV CONFIG_ROOT_REPOSITORIES_DIR ${USER_HOME}/borges/root

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get install --assume-yes apt-utils sudo vim

COPY build/bin/rovers_* /usr/local/bin/rovers
COPY build/bin/borges_* /usr/local/bin/borges

RUN apt-get install --assume-yes software-properties-common && \
    add-apt-repository --yes ppa:alexlarsson/flatpak && \
    apt-get update && \
    apt-get install --assume-yes libostree-1-1 tzdata
COPY build/bin/bblfshd_* /usr/local/bin/bblfshd
COPY build/bin/bblfshctl_* /usr/local/bin/bblfshctl

COPY build/spark/spark.tgz /tmp/spark/spark.tgz
RUN apt-get install --assume-yes openjdk-8-jre && \
    mkdir -p /tmp/spark/unzipped && \
    tar -xzf /tmp/spark/spark.tgz --directory=/tmp/spark/unzipped && \
    mv /tmp/spark/unzipped/spark* ${USER_HOME}/spark && \
    rm -rf /tmp/spark
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV SPARK_HOME ${USER_HOME}/spark

RUN apt-get --assume-yes install python3 python3-pip && \
    pip3 install --upgrade pip && \
    pip3 install sourced-engine jupyter
ENV PYSPARK_PYTHON python3

COPY examples ${USER_HOME}/examples
COPY sources/entrypoint.sh ${USER_HOME}/entrypoint.sh
COPY sources/.bashrc ${USER_HOME}/.bashrc-custom
RUN chmod +x ${USER_HOME}/entrypoint.sh && \
    echo "source ${USER_HOME}/.bashrc-custom" >> ${USER_HOME}/.bashrc

ENTRYPOINT ${USER_HOME}/entrypoint.sh
