FROM ubuntu:16.04

ENV USER_HOME /root
WORKDIR ${USER_HOME}

ENV PATH $PATH:${USER_HOME}/spark/bin

ENV CONFIG_DBHOST 127.0.0.1
ENV CONFIG_BROKER_URL amqp://guest:guest@127.0.0.1:5672/
ENV CONFIG_TEMP_DIR /tmp/borges
ENV CONFIG_ROOT_REPOSITORIES_DIR ${USER_HOME}/borges/root

ARG CONFIG_ENGINE_VERSION
ENV CONFIG_ENGINE_VERSION ${CONFIG_ENGINE_VERSION}

ARG CONFIG_JUPYTER_PORT
ENV CONFIG_JUPYTER_PORT ${CONFIG_JUPYTER_PORT}

# Prepare the environment
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get install --assume-yes --no-install-suggests --no-install-recommends \
        apt-utils sudo vim

# Install Rovers, Borges and its dependences: PostgreSQL and RabbitMQ
COPY build/rabbitmq/key.asc /tmp/rabbitmq-key.asc
COPY sources/rabbitmq/rabbitmq.list /etc/apt/sources.list.d/rabbitmq.list
RUN apt-key add /tmp/rabbitmq-key.asc && \
    apt-get update && \
    apt-get install --assume-yes --no-install-suggests --no-install-recommends \
        postgresql rabbitmq-server && \
    rm -rf /tmp/rabbitmq-key.asc
COPY build/bin/rovers_* /usr/local/bin/rovers
COPY build/bin/borges_* /usr/local/bin/borges

# Install Babelfish and its dependencies
RUN apt-get install --assume-yes --no-install-suggests --no-install-recommends \
        software-properties-common && \
    add-apt-repository --yes ppa:alexlarsson/flatpak && \
    apt-get update && \
    apt-get install --assume-yes --no-install-suggests --no-install-recommends \
        libostree-1-1 tzdata
COPY build/bin/bblfshd_* /usr/local/bin/bblfshd
COPY build/bin/bblfshctl_* /usr/local/bin/bblfshctl

# Install Spark and its dependencies: Java JRE
COPY build/spark/spark.tgz /tmp/spark/spark.tgz
RUN apt-get install --assume-yes --no-install-suggests --no-install-recommends \
        openjdk-8-jre && \
    mkdir -p /tmp/spark/unzipped && \
    tar -xzf /tmp/spark/spark.tgz --directory=/tmp/spark/unzipped && \
    mv /tmp/spark/unzipped/spark* ${USER_HOME}/spark && \
    rm -rf /tmp/spark
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV SPARK_HOME ${USER_HOME}/spark

# Install Python, source{d} py-engine and Jupyter
RUN apt-get install --assume-yes --no-install-suggests --no-install-recommends \
        python3 python3-pip && \
    pip3 install --upgrade --no-cache-dir pip setuptools && \
    pip3 install --upgrade --no-cache-dir sourced-engine jupyter
ENV PYSPARK_PYTHON python3
ENV PYSPARK_SUBMIT_ARGS --packages tech.sourced:engine:${CONFIG_ENGINE_VERSION} pyspark-shell


# Prepares .bashrc, the container entrypoint and copies the examples
COPY examples ${USER_HOME}/examples
COPY sources/entrypoint.sh ${USER_HOME}/entrypoint.sh
COPY sources/.bashrc ${USER_HOME}/.bashrc-custom
RUN chmod +x ${USER_HOME}/entrypoint.sh && \
    echo "source ${USER_HOME}/.bashrc-custom" >> ${USER_HOME}/.bashrc

EXPOSE ${CONFIG_JUPYTER_PORT}

ENTRYPOINT ${USER_HOME}/entrypoint.sh
