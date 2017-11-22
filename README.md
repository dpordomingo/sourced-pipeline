source{d} environment
====

Based in the [source{d} stack deployment process](https://docs.google.com/document/d/18t1wN8WfcZqxsE0dpMBXyqO0Jk94aeaSgTn7ZGVOHB0) guides, this projects builds a docker image containing the full stack with a single command.

- [source{d} engine](https://engine.sourced.tech)
- [babelfish](https://doc.bblf.sh)
- [rovers](https://github.com/src-d/rovers) and [borges](https://github.com/src-d/borges)
- [Jupyter Notebook](http://jupyter.org)
- [Apache Spark](https://spark.apache.org) for Hadoop (and [Java](https://www.java.com))
- [RabbitMQ](https://www.rabbitmq.com) and [PostgreSQL](https://www.postgresql.org)


## Running the environment:

```shell
make fresh-start;
```

And then:
- access the container in a bash tty running `make sh`
- open the Jupyter Notebook at [http://localhost:8888](http://localhost:8888)

### Inside the container tty

Inside the source{d} environment tty you'll find all the tools described in the intro of this README.md, plus some aliases to make it easy to run some common commands

- `q` exists the container
- `pyspark` opens a pyspark cli with source{d} engine pre-loaded
- `spark-shell` opens a spark-shell cli with source{d} engine pre-loaded
- `addRepo <REPO_URL>` fetches a repository and stores its `.siva` into `/root/borges/root`

_Example:_

You can store [python/tlsproxy](https://github.com/python/tlsproxy ) and [python/devinabox](https://github.com/python/devinabox) and run the [example query](makefiles/examples/ex.py) running:

```shell
addRepo https://github.com/python/tlsproxy 
addRepo https://github.com/python/devinabox
python3 examples/ex.py
```

## Manage the environment

From your host machine you will be able to run, rebuild, clean... the environment

- **`make fresh-start`**: most common command, to build a fresh new environment
- `make restart`: drop and rises a fresh new container,
- `make sh`: access the running container,
- `make rebuild`: rebuilds the docker image,
- `make logs`: outputs the container logs,
- `make clean`: removes all built dependencies, images and running containers.