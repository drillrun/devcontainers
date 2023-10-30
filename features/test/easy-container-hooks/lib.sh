ensure_hook_dir() {
    mkdir -p $1;
}

write_test_hook() {
    OUTPUT=${2:-$(basename $1)};

    cat <<HOOK > "$1/test_${OUTPUT}.sh"
#!/usr/bin/env sh

set -e

echo ${OUTPUT}
HOOK
}

get_hook_runner() {
    case $1 in
        on-create)      echo "/usr/local/bin/ezdc_onCreate.sh";;
        post-attach)    echo "/usr/local/bin/ezdc_postAttach.sh";;
        post-create)    echo "/usr/local/bin/ezdc_postCreate.sh";;
        post-start)     echo "/usr/local/bin/ezdc_postStart.sh";;
        update-content) echo "/usr/local/bin/ezdc_updateContent.sh";;
    esac
}

test_hook() {
    EXPECTATION=$1
    HOOK=$2

    cat $(get_hook_runner $HOOK)

    check "runner-installed $HOOK" sh -c "cat $(get_hook_runner $HOOK) | grep HOOKS=${EXPECTATION}"
    check "runner-runs-hooks $HOOK" sh -c "$(get_hook_runner $HOOK) | grep $HOOK"
}


# POSIX-limited reimplementation of dev-container-features-test-lib's check and reportResults

notice() { echo -e "\n$@\\033[37m"; }
failureNotice() {   echo -e "$@" 1>&2; }

fail() {
    local LABEL=$1;

    FAILED="${FAILED} ${LABEL}";
    failureNotice "❌ $LABEL check failed." 1>&2;
}

check() {
    local LABEL=$1; shift;

    notice "🔄 Testing '$LABEL'"
    if "$@"; then
        notice "✅  Passed '$LABEL'!";
        return 0;
    else fail $LABEL;
        return 1;
    fi
}

reportResults() {
    if [ ! -z "${FAILURE}" ]; then
        failureNotice "💥  Failed tests: ${FAILURE}";
        exit 1;
    else
        notice "Test passed!";
        exit 0;
    fi
}