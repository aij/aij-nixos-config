#!/usr/bin/env bash

set -euxo pipefail

if [ $# -lt 1 ]; then
    echo "Usage: $0 <device> [zfs create opts]" >&2
    echo "Eg: $0 /dev/sdb2" >&2
    echo "Eg1: enc_opts='' mkswap=true $0 /dev/nvme0n1"
    echo "Eg2: $0 'mirror /dev/sdb2 /dev/sdf2 mirror /dev/sdc /dev/sdg'"
    exit 1
fi

set -x

poolname=rpool
device=$1
shift
echo extra_opts = $@
#enc_opts=${enc_opts:--O encryption=on  -O keylocation=prompt -O keyformat=passphrase}
# FIXME: Above doesn't allow it to be set to empty
enc_opts=${enc_opts:-}
echo enc_opts = $enc_opts

zpool create             \
     -o ashift=12        \
     -o altroot=/mnt     \
     -O atime=off        \
     -O relatime=on      \
     -O compression=on   \
     -O snapdir=visible  \
     -O xattr=sa         \
     -O acltype=posixacl \
     -O dedup=on         \
     $enc_opts           \
     "$@"                \
    "$poolname"          \
    $device


# dataset for / (root)
zfs create -o mountpoint=legacy "$poolname/ROOT"
zpool set bootfs="$poolname/ROOT" "$poolname"

# Keep /nix separate because nix likes to sync -f /nix/store
subdirs="nix var tmp home"

for d in $subdirs; do
    zfs create -o mountpoint=legacy "$poolname/$d"
done

zfs set com.sun:auto-snapshot=true "$poolname/home"



# dataset for swap
# Warning: Not tested recently. I have not been using swap.
if [ -n "${mkswap:-}" ]; then
    mem_amount=`awk '/MemTotal/ {print $2$3}'`
    zfs create -o compression=off -o dedup=off -V "${mem_amount}" "$poolname/SWAP"
    mkswap "/dev/zvol/$poolname/SWAP"
    swapon "/dev/zvol/$poolname/SWAP"
fi


mydir="$(dirname "$0")"

"$mydir"/mount-zfs.sh

# mkfs.vfat -n efiboot /dev/...
# mount EFI partition at future /boot
#mount  /dev/disk/by-label/efiboot /mnt/boot

"$mydir"/generate-hostid.sh
