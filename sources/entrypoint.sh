#!/bin/bash

source ${USER_HOME}/.bashrc-custom

echo && echo "Starting RabbitMQ and PostgreSQL..."
service rabbitmq-server start
service postgresql start

echo && echo "Creating '${CONFIG_DBUSER}' user..."
cd /home
sudo -u postgres psql -c "CREATE USER ${CONFIG_DBUSER} WITH PASSWORD '${CONFIG_DBPASS}';"
sudo -u postgres psql -c "CREATE DATABASE ${CONFIG_DBNAME} OWNER ${CONFIG_DBUSER}"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE ${CONFIG_DBNAME} TO ${CONFIG_DBUSER};"
cd -

echo && echo "Initializing rovers and borges..."
rovers initdb
borges init
mkdir -p ${CONFIG_ROOT_REPOSITORIES_DIR}

echo && echo "Starting babelfish..."
bblfshd &
bblfshctl driver install --all
bblfshctl driver list

echo && echo "DONE......"
sleep infinity
