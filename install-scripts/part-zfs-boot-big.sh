#!/bin/sh

# Create a 512MB /boot partition, and allocate the rest for ZFS
# Intended for larger disk, so use gpt and reserve a 1MiB BIOS_Boot partition for grub.
sfdisk --label gpt --wipe always "$@" <<EOF
size=1MiB type=21686148-6449-6E6F-744E-656564454649
size=512MiB bootable type=L
type=L
EOF
