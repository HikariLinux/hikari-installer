#!/bin/sh
# SPDX-License-Identifier: MIT

# Truncation guard
if true; then
    set -e

    if [ ! -e /System ]; then
        echo "You appear to be running this script from Linux or another non-macOS system."
        echo "Hikari Linux can only be installed from macOS (or recoveryOS)."
        exit 1
    fi

    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8
    export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

    if ! curl --no-progress-meter file:/// >/dev/null 2>&1; then
        echo "Your version of cURL is too old. This usually means your macOS is very out"
        echo "of date. Installing Hikari Linux requires at least macOS version 13.5."
        exit 1
    fi

    export DISTRO="${DISTRO:-Hikari Linux}"
    export DISTRO_DOCS="${DISTRO_DOCS:-https://github.com/HikariLinux/hikari-installer}"
    export INSTALLER_BASE="${INSTALLER_BASE:-https://github.com/HikariLinux/hikari-installer/releases/latest/download}"
    export VERSION_FLAG="${VERSION_FLAG:-$INSTALLER_BASE/latest}"
    export INSTALLER_DATA="${INSTALLER_DATA:-$INSTALLER_BASE/installer_data.json}"
    export REPO_BASE="${REPO_BASE:-$INSTALLER_BASE}"

    #TMP="$(mktemp -d)"
    TMP=/tmp/hikari-install

    echo
    echo "Bootstrapping installer:"

    if [ -e "$TMP" ]; then
        mv "$TMP" "$TMP-$(date +%Y%m%d-%H%M%S)"
    fi

    mkdir -p "$TMP"
    cd "$TMP"

    echo "  Checking version..."

    PKG_VER="$(curl --fail --no-progress-meter -L "$VERSION_FLAG")"
    echo "  Version: $PKG_VER"

    PKG="installer-$PKG_VER.tar.gz"

    echo "  Downloading..."

    curl --fail --no-progress-meter -L -o "$PKG" "$INSTALLER_BASE/$PKG"
    curl --fail --no-progress-meter -L -o installer_data.json "$INSTALLER_DATA"

    echo "  Extracting..."

    tar xf "$PKG"

    echo "  Initializing..."
    echo

    if [ "$USER" != "root" ]; then
        echo "The installer needs to run as root."
        echo "Please enter your sudo password if prompted."
        exec caffeinate -dis sudo -E ./install.sh "$@"
    else
        exec caffeinate -dis ./install.sh "$@"
    fi
fi
