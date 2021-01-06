#!/usr/bin/env bash

# Based on https://github.com/danielfullmer/nixos-config/commit/5e35e83441fcc25ce6869a0c036af010880d92bc

#export NIX_PATH=nixpkgs=https://nixos.org/channels/nixpkgs-unstable/nixexprs.tar.xz

mkdir logs

all_machines="`ls machines/`"
all_channels="stable unstable"

machines=${1:-"$all_machines"}
channels=${2:-"$all_channels"}

rc=0

for name in $machines; do
    for channel in $channels; do

	echo "Building: $name $channel"
	nix-build "<nixpkgs/nixos>" -A system \
		  -I nixpkgs=$PWD/$channel -I nixos-config=$PWD/machines/$name \
		  --no-out-link >logs/$name-$channel.out 2>&1
	if [ $? == 0 ]; then
            echo "Success!";
	else
            echo "FAILED to build $name $channel";
            rc=1
	fi

    done
done

exit $rc
