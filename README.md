# Catacomb Linux Packages

This repository contains package manifests and toolings for the Catacomb Linux
Mobile DE.

## Archlinux

Packages for ALARM are automatically updated and published to
<https://catacombing.org/catacomb/aarch64/>. You can use this repository by
adding the following lines to your `/etc/pacman.conf`:

```text
[catacomb]
Server = https://catacombing.org/$repo/$arch/
```

To be able to validate the repository's signatures, you'll also have to add and
trust the build system's PGP key:

```sh
pacman-key --recv-keys 733163AA31950B7F4BE7EC4082CE6C29C7797E04
pacman-key --lsign-key 733163AA31950B7F4BE7EC4082CE6C29C7797E04
```

If you want to try Catacomb on a PinePhone or PinePhone Pro, you can download a
prebuilt image from https://catacombing.org.

## Catacomb Installation

After setting up the Catacomb repository, you can install `catacomb-meta` to
install all Catacomb packages, or pick the ones you would like installed. The
meta package will enable the `tinydm` service using the `catacomb.desktop`
session, to automatically login and start Catacomb after boot.
