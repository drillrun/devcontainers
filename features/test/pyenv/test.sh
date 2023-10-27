#!/usr/bin/env sh
#
# This test file will be executed against an auto-generated devcontainer.json that
# includes the "pyenv" feature with no options.
#
#
# This test can be run with the following command:
#
#    devcontainer features test \ 
#                   --features pyenv \
#                   --base-image alpine:latest \
#                   .

set -e

. ./lib.sh

check "pyenv installed" sh -c "pyenv --version | grep 2.3.31"
check "pyenv installed latest" sh -c "pyenv versions | grep 3.12.0"
check "pyenv includes ctypes, etc" sh -c "python -c \"import ctypes; import lzma; import sqlite3;\""

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults