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