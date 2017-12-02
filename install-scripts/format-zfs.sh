#!/usr/bin/env bash

set -e

if [ $# -lt 2 ]; then
    echo "Usage: $0 <poolname> <device> [zfs create opts]" >&2
    exit 1
fi

set -x

poolname=$1
shift
device=$1
shift
echo extra_opts = $@

zpool create             \
     -o ashift=12        \
     -o altroot=/mnt     \
     -O atime=on         \
     -O relatime=on      \
     -O compression=on   \
     -O snapdir=visible  \
     -O xattr=sa         \
     -O dedup=on         \
     "$@"                \
    "$poolname"          \
    "$device"


# dataset for / (root)
zfs create -o mountpoint=legacy "$poolname/ROOT"
zpool set bootfs="$poolname/ROOT" "$poolname"
# nix likes to sync -f /nix/store
zfs create -o mountpoint=legacy "$poolname/NIX"
zfs create -o mountpoint=legacy "$poolname/VAR"
zfs create -o mountpoint=legacy "$poolname/HOME"
zfs set com.sun:auto-snapshot=true "$poolname/HOME"



# mount the root dataset at /mnt
mount -t zfs "$poolname/ROOT" /mnt

mkdir /mnt/{boot,home,var,nix}

mount -t zfs "$poolname/NIX" /mnt/nix
mount -t zfs "$poolname/VAR" /mnt/var
mount -t zfs "$poolname/HOME" /mnt/home


# dataset for swap
if [ "$mkswap" ]; then
    mem_amount=`awk '/MemTotal/ {print $2$3}'`
    zfs create -o compression=off -o dedup=off -V "${mem_amount}" "$poolname/SWAP"
    mkswap "/dev/zvol/$poolname/SWAP"
    swapon "/dev/zvol/$poolname/SWAP"
fi

# mount EFI partition at future /boot
mount  /dev/disk/by-label/efiboot /mnt/boot
