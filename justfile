# set positional-arguments

FEATURE_IMAGE_BASE := env_var_or_default("FEATURE_IMAGE_BASE", "debian:12-slim")

default:
    @just --list


test-all target image="alpine:latest":
    devcontainer features test -p features -i {{ image }} -f {{ file_name(target) }}

test target image="alpine:latest":
    devcontainer features test -p features -i {{ image }} --skip-scenarios -f {{ file_name(target) }}

publish target tag="all":
    just publish-{{ parent_directory(target) }} {{ file_name(target) }} tag={{ replace(tag, "tag=", "") }}

publish-features target tag="all":
    devcontainer features publish -n drillrun/devcontainers/features features/src/{{ target }}

publish-images target tag="all":
    just build images/{{ target }} tag={{ replace(tag, "tag=", "") }} push=true

build target tag="all" push="false":
    #!/usr/bin/env bash

    TAG="{{ tag }}"
    TAG=${TAG##tag=}

    SHOULD_PUSH="{{ push }}"
    SHOULD_PUSH=${SHOULD_PUSH##push=}

    if [[ "${TAG}" == "all" ]]; then
        for TAG in $(basename -a {{ join(target, "*/") }}); do
            just build {{ target }} tag=${TAG} push=${SHOULD_PUSH} &
        done

        wait
    else
        set -eux

        set -- $(devcontainer build --workspace-folder {{ join(target, "${TAG}") }} | jq -r "(.outcome, .imageName[0])");
        STATUS=$1;
        IMAGE=$2;

        if [[ "${STATUS}" != "success" ]]; then
            echo 1
        fi

        if [[ $SHOULD_PUSH ]]; then
            docker image tag ${IMAGE}
            docker image push
        fi
    fi