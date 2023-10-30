#!/usr/bin/env sh

set -e

# Checks if a command is installed
check() { type $1 2>&1 > /dev/null; }
check_packages() {
	COMMAND=$1; shift;
	ARGS=$@;
	if [ "$#" = 0 ]; then ARGS=${COMMAND}; fi

	check $COMMAND || $INSTALLER $ARGS
}

apk_install() {
	check apk && apk add $@
}

apt_install() {
	check apt-get && ( apt-get update; apt-get -y --no-install-recommends install $@; )
}

case "$(cat /etc/os-release | grep ^ID | cut -d '=' -f 2)" in
	alpine)
		INSTALLER=apk_install;
		$INSTALLER "build-base musl-dev libffi-dev openssl-dev bzip2-dev zlib-dev xz-dev readline-dev sqlite-dev tk-dev"
		;;
	debian)
		INSTALLER=apt_install;
		$INSTALLER "build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev"
		;;
	*)
		echo "Unsupported distribution!";
		exit 999;
esac

VERSION=${VERSION:-"latest"}
ADDITIONAL_VERSIONS=${ADDITIONALVERSIONS:-""}


check_packages bash
check_packages git
check_packages curl "curl ca-certificates"
env                                     \
	PYENV_ROOT="/usr/local/share/pyenv" \
	bash -v ./pyenv-installer


cat > /etc/profile.d/99_pyenv.sh<<-'EOF'
	export PYENV_ROOT="/usr/local/share/pyenv"
	command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
	eval "$(pyenv init -)"
EOF


if [ "${VERSION}" != "none" ]; then
	cat > /tmp/install_versions.sh<<-'EOF'
		#!/usr/bin/bash

		source /etc/profile.d/99_pyenv.sh;

		if [[ "${VERSION}" = "latest" ]]; then
			VERSION=$(pyenv latest -k 3)
		fi

		GLOBAL=${VERSION}
		VERSIONS=($VERSION "${ADDITIONAL_VERSIONS//,/ }");

		for VERSION in ${VERSIONS[@]}; do
			pyenv install ${VERSION};
		done

		pyenv global ${GLOBAL}
	EOF

	env VERSION="${VERSION}"                         \
		ADDITIONAL_VERSIONS="${ADDITIONAL_VERSIONS}" \
		bash /tmp/install_versions.sh

	rm /tmp/install_versions.sh
fi