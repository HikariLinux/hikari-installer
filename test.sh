#!/bin/sh
set -e

cd "$(dirname "$0")"
base="$PWD"

if [ -e $HOME/.cargo/env ] ; then
    source $HOME/.cargo/env
fi

export INSTALLER_BASE="${INSTALLER_BASE:-http://localhost:5000/releases}"
export REPO_BASE="${REPO_BASE:-$INSTALLER_BASE}"

./scripts/build-logo.sh

make -C "m1n1" RELEASE=1 CHAINLOADING=1 -j4

sudo rm -rf /tmp/hikari-install
mkdir -p /tmp/hikari-install

git describe --tags --always --dirty > /tmp/hikari-install/version.tag

cd /tmp/hikari-install
ln -sf "$base/src"/* .
ln -sf "$base/asahi_firmware" .
mkdir -p boot
ln -sf "$base/m1n1/build/m1n1.bin" boot/m1n1.bin
ln -sf "$base/build/logo.icns" logo.icns
ln -sf "$base/data/installer_data.json" installer_data.json

sudo -E python3 main.py
