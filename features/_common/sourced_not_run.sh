ensure_sourced() {
    declare -p FUNCNAME 2>&1 > /dev/null;

    if [[ "${FUNCNAME[1]}" != "source" ]]; then
        echo "$0 should be sourced, not executed."
        exit 1
    fi
}