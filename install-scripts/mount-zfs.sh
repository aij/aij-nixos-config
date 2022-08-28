#!/usr/bin/env bash

set -euxo pipefail

poolname=rpool
subdirs="nix var tmp home"
dest="/mnt"

# mount the root dataset at /mnt
mount -t zfs "$poolname/ROOT" "$dest"

for d in $subdirs; do
    mkdir -p "$dest/$d"
    mount -t zfs "$poolname/$d" "$dest/$d"
done

# Try to mount boot partition
mkdir -p "$dest/boot"
mount  /dev/disk/by-label/boot "$dest/boot"
