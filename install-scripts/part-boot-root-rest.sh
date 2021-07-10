#!/bin/sh

# Create a 512MiB /boot partition, 199MB /, and allocate the rest for whatever.
# Intended for larger disk, so use gpt and reserve a 1MiB BIOS_Boot partition for grub.
sfdisk --label gpt "$@" <<EOF
size=1MiB type=21686148-6449-6E6F-744E-656564454649
size=512MiB bootable type=L
size=199GB type=L
type=L
EOF
