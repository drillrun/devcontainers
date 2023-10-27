#!/usr/bin/env sh
#
# This test file will be executed against an auto-generated devcontainer.json that
# includes the "pyenv" feature with no options.
#
#
# This test can be run with the following command:
#
#    devcontainer features test \ 
#                   --features git \
#                   --base-image alpine:latest \
#                   .

set -e

. ./lib.sh

check "git installed" sh -c "git --version"

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults