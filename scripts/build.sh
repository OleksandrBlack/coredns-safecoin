#!/bin/bash

set -exuo pipefail

WORKDIR="$(pwd)"
BUILD_DIR=$(mktemp -d)
COREDNS_VERSION="v1.7.1"

git clone --branch ${COREDNS_VERSION} https://github.com/OleksandrBlack/coredns ${BUILD_DIR}
cd ${BUILD_DIR}
echo "dnsseed:github.com/oleksandrblack/dnsseeder/dnsseed" >> plugin.cfg
echo "replace github.com/btcsuite/btcd => github.com/gtank/btcd v0.0.0-20191012142736-b43c61a68604" >> go.mod
make

if [ ! -d ${WORKDIR}/build_output ]; then
    mkdir ${WORKDIR}/build_output
fi

cp ${BUILD_DIR}/coredns ${WORKDIR}/build_output/coredns
cd ${WORKDIR}
rm -rf ${BUILD_DIR}
