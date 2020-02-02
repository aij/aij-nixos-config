#!/usr/bin/env bash

# Based on https://github.com/danielfullmer/nixos-config/commit/5e35e83441fcc25ce6869a0c036af010880d92bc

#export NIX_PATH=nixpkgs=https://nixos.org/channels/nixpkgs-unstable/nixexprs.tar.xz

mkdir logs

rc=0

for d in machines/*; do
    name=`basename $d`
    for channel in stable unstable; do

	echo "Building: $name $channel"
	nix-build "<nixpkgs/nixos>" -A system \
		  -I nixpkgs=$PWD/$channel -I nixos-config=$PWD/machines/$name \
		  -o result-$name-$channel >logs/$name-$channel.out 2>&1
	if [ $? == 0 ]; then
            echo "Success!";
	else
            echo "FAILED to build $name $channel";
            rc=1
	fi

    done
done

exit $rc
