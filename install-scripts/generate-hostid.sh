#!/bin/sh

echo Suggested NixOS config for generated hostid:
cksum /etc/machine-id | awk '{ printf "networking.hostId = \"%x\";", $1 }'
