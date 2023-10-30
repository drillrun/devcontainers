#!/usr/bin/env sh

set -e

. ./lib.sh

check "pyenv installed" sh -c "pyenv --version | grep 2.3.31"
check "pyenv installed previous version" sh -c "pyenv versions | grep 3.11"

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults