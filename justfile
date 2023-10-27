# set positional-arguments

FEATURE_IMAGE_BASE := env_var_or_default("FEATURE_IMAGE_BASE", "debian:12-slim")

default:
    @just --list


test-all target image="alpine:latest":
    devcontainer features test -p features -i {{ image }} -f {{ file_name(target) }}

test target image="alpine:latest":
    devcontainer features test -p features -i {{ image }} --skip-scenarios -f {{ file_name(target) }}

build target tag="all":
    #!/usr/bin/env bash
    if [[ "{{ tag }}" == "all" ]]; then
        for TAG in $(basename -a {{ join(target, "*/") }}); do
            just build {{ target }} ${TAG} &
        done

        wait
    else
        set -eux
        devcontainer build --workspace-folder {{ join(target, tag) }}
    fi

squish target tag="all":

