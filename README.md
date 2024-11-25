# Catacomb Linux Packages

This repository contains package manifests and toolings for the Catacomb Linux
Mobile DE.

## Archlinux

Packages for ALARM are automatically updated and published to
<https://christianduerr.com/catacomb/aarch64/>. You can use this repository by
adding the following lines to your `/etc/pacman.conf`:

```text
[catacomb]
Server = https://christianduerr.com/$repo/$arch/
```

To be able to validate the repository's signatures, you'll also have to add and
trust the build system's PGP key:

```sh
pacman-key --recv-keys 733163AA31950B7F4BE7EC4082CE6C29C7797E04
pacman-key --lsign-key 733163AA31950B7F4BE7EC4082CE6C29C7797E04
```
