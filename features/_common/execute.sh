COMMON_PATH=$(dirname ${BASH_SOURCE[0]});

source ${COMMON_PATH}/sourced_not_run.sh
ensure_sourced




# check_execute <command> <args>
check_execute() {
    local COMMAND=$1; shift;
    local ARGS=$@;

    if [ ! $(type ${COMMAND} > /dev/null 2>&1) ]; then return 1;
    else
        ${COMMAND} ${ARGS}
    fi
}