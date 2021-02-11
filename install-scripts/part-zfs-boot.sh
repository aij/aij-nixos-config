#!/bin/sh

# Create a 512MB /boot partition, and allocate the rest for ZFS
sfdisk "$@" <<EOF
size=512MiB bootable type=L
type=L
EOF
