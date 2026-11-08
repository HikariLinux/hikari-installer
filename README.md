# Hikari Linux installer

<img src="assets/hikari-linux.svg" alt="Hikari Linux" width="128">

The Hikari Linux installer prepares Apple Silicon Macs for Linux. It is based
on our preserved MIT fork of the Asahi Linux installer, retaining its APFS
partitioning, boot policy and image installation framework.

This is a development repository. M6 support and Hikari installation images
are still being integrated; a public installation release is not available yet.

## Building

Initialize the pinned MIT m1n1 fork:

```sh
git submodule update --init --recursive
./build.sh
```

The build produces an installer tree under `releases/`. It downloads and caches
Python and libffi under `dl/`. The existing build dependencies include an
AArch64 toolchain, Rust, `wget`, `curl`, `jq`, libarchive, and Python `certifi`.
Logo generation also requires `rsvg-convert` and either macOS `iconutil` or
Linux `png2icns` from `icnsutils`.

The original logo is `assets/hikari-linux.svg`. ICNS files are generated at
build time. Set `LOGO` to use a different ICNS file or `M1N1_STAGE1` to use a
prebuilt stage 1 image.

## Installer configuration

The bootstrap scripts support `DISTRO`, `DISTRO_DOCS`, `VERSION_FLAG`,
`INSTALLER_BASE`, `INSTALLER_DATA`, and `REPO_BASE` overrides. Local development
uses `scripts/bootstrap.sh`; the dev and production scripts target Hikari's
GitHub release assets when those releases become available. Distribution image
metadata must be supplied with the release. No reporting endpoint is configured
by default.

The `asahi_firmware` module and existing on-disk firmware conventions retain
their names for compatibility.

## License

Copyright The Asahi Linux Contributors. Hikari Linux changes and artwork are
provided under the MIT license. See [LICENSE](LICENSE).

The vendored [python-asn1](https://github.com/andrivet/python-asn1) module also
uses the MIT license.
