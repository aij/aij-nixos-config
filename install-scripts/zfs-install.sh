#!/usr/bin/env bash

set -euxo pipefail

mydir="$(dirname "$0")"

if [ $# -ne 1 ]; then
    echo "Usage $0 <target_disk>"
    echo "<target_disk> will be repartitioned, formatted, and mounted under /mnt"
    echo "Eg: $0 /dev/disk/by-id/foobar"
    echo "Note: Currently requires that target_disk partitions be named target_disk-part2 etc"
    exit 1
fi

disk=$1

#TODO echo "Will delete everything on $disk. Are you sure?"

# For SSD TRIM/discard is good, but it needs to be run with -f to
# destroy existing data and I'm not sure I want to do that automatically...
# blkdiscard $disk

$mydir/part-zfs-boot.sh $disk

# Wait for partitions to be re-read
sleep 1
udevadm settle

# Getting partition names in general is not as trivial as it should be
# /dev/sdn -> sdn1 sdn2 etc
# /dev/nvme0n1 -> nvme0n1p1 nvme0n1p2 etc
# /dev/disk/by-id always adds -part1 style suffixes though.
bootpart=$disk-part1
rootpart=$disk-part2

test -e $bootpart
test -e $rootpart

mkfs.ext4 -L boot $bootpart

$mydir/format-zfs.sh $rootpart

#$mydir/mount-zfs.sh

#$mydir/generate-hostid.sh

echo "Now nixos-generate-config --root /mnt && vi /mnt/etc/nixos/configuration.nix && nixos-install"
