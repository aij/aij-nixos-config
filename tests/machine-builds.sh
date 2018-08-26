#!/usr/bin/env bash

# Based on https://github.com/danielfullmer/nixos-config/commit/5e35e83441fcc25ce6869a0c036af010880d92bc

#export NIX_PATH=nixpkgs=https://nixos.org/channels/nixpkgs-unstable/nixexprs.tar.xz

mkdir logs

rc=0

for d in machines/*; do
    name=`basename $d`
    echo "BUILDING: $name"
    nix-build "<nixpkgs/nixos>" -A system -I "nixos-config=machines/${name}/" -o result-$name >logs/$name.out 2>&1
    if [ $? == 0 ]; then
        echo "SUCCESS";
    else
        echo "FAILED";
        rc=1
    fi
done

exit $rc
