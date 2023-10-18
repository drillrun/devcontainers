#!/usr/bin/env bash


COMMON_PATH=$(dirname ${BASH_SOURCE[0]});

source ${COMMON_PATH}/execute.sh
source ${COMMON_PATH}/sourced_not_run.sh

ensure_sourced

check_packages() {
    apk_install $@ || apt_install $@ || yum_install $@ || dnf_install $@
}

apk_install() {
    check_execute apk -s $@ || check_execute apk install $@;
}

apt_install() {
    retrieve_pkg_lists() {
        local FORCE=${1:-""};
        local APT_LISTS="/var/lib/apt/lists";

        if [ ! -z "$FORCE" ] || [ ! -d $APT_LISTS ] || [ "$(ls $APT_LISTS | wc -l)" = "0" ]; then
            apt-get update
        fi
    }

    check_execute dpkg -s $@ || (retrieve_pkg_lists && apt-get install -qq --no-install-recommends $@);
}

yum_install() {
    check_execute rpm -q $@ || check_execute yum install -y $@
}
dnf_install() {
    check_execute rpm -q $@ || check_execute dnf install -y $@
}