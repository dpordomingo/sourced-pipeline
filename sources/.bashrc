# Custom aliases
alias q='exit 0'
alias pyspark='${USER_HOME}/spark/bin/pyspark --packages tech.sourced:engine:${CONFIG_ENGINE_VERSION}'
alias spark-shell='${USER_HOME}/spark/bin/spark-shell --packages tech.sourced:engine:${CONFIG_ENGINE_VERSION}'
alias roversFetch='rovers repos --provider=github'
alias borgesProduce='borges producer'
alias borgesConsume='borges consumer'
alias borgesPack='function _F { borges pack --file=$1 --to=${CONFIG_ROOT_REPOSITORIES_DIR}; }; _F '
alias addRepo='function _F { echo $1 > /tmp/repos.txt && borgesPack /tmp/repos.txt; }; _F '

# Env vars
export PYSPARK_SUBMIT_ARGS="--packages tech.sourced:engine:${CONFIG_ENGINE_VERSION} pyspark-shell"
