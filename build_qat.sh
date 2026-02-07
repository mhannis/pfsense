#!/bin/sh
set -eu

usage() {
	echo "Usage: $0 [iso|memstick|memstickserial|memstickadi|all] [--skip-setup]"
	exit 1
}

if [ "$(uname -s)" != "FreeBSD" ]; then
	echo "ERROR: pfSense build must run on FreeBSD."
	exit 1
fi

IMAGE_TYPE="memstick"
DO_SETUP="yes"

for arg in "$@"; do
	case "$arg" in
		iso|memstick|memstickserial|memstickadi|all)
			IMAGE_TYPE="$arg"
			;;
		--skip-setup)
			DO_SETUP="no"
			;;
		-h|--help)
			usage
			;;
		*)
			echo "Unknown argument: $arg"
			usage
			;;
	esac
done

ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
BUILD_CONF="${ROOT_DIR}/build.conf"
LOADER_APPEND="${ROOT_DIR}/loader.conf.append"

if [ ! -f "${BUILD_CONF}" ]; then
	echo "ERROR: Missing ${BUILD_CONF}"
	echo "Copy build.conf.qat-c3xxx.sample to build.conf first."
	exit 1
fi

if [ ! -f "${LOADER_APPEND}" ]; then
	echo "ERROR: Missing ${LOADER_APPEND}"
	exit 1
fi

if ! grep -q 'MODULES_OVERRIDE_APPEND=.*qat/qat' "${BUILD_CONF}"; then
	echo "ERROR: build.conf does not contain QAT module override configuration."
	exit 1
fi

if ! grep -q 'LOADERCONF_APPEND_FILE=' "${BUILD_CONF}"; then
	echo "ERROR: build.conf does not set LOADERCONF_APPEND_FILE."
	exit 1
fi

cd "${ROOT_DIR}"

if [ "${DO_SETUP}" = "yes" ]; then
	echo "==> Running builder setup"
	./build.sh --setup
fi

echo "==> Building image type: ${IMAGE_TYPE}"
./build.sh "${IMAGE_TYPE}"

echo "==> Build completed"
echo "Output directory:"
echo "    ${ROOT_DIR}/tmp/nonSense/"
