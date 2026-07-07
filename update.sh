#!/usr/bin/env bash

set -e -x

# TODO: Check repo cleanliness


function usage() {
    echo "$0 [stable|unstable] [--nom] [<build_opts>]"
    exit 1
}

which=''
build_opts=()
nix_build=(time nix-build)

while [ $# -gt 0 ]; do
    case "$1" in
        stable|unstable)
            if test -n "$which"; then usage; fi
            which="$1"
            shift
            ;;
        --nom)
            nix_build=(nom-build)
            shift
            ;;
        -*)
            build_opts+=("$1")
            shift
            ;;
    esac
done

# Is this equivalent, or close enough?
git submodule update --remote $which

# Update flake.lock to match
nix flake update

# Test that everything still builds
"${nix_build[@]}" tests/machine-builds.nix "${build_opts[@]}"

# Test colmena can still build my configuration with new submodules
test -e ../hive.nix && {
    nix-shell -p colmena --run 'cd .. && colmena apply build'
}
    
git add stable unstable flake.lock

if test -n "$which"; then
    msg="Update nixpkgs $which"
else
    msg='Update nixpkgs'
fi
GIT_AUTHOR_NAME=update.sh GIT_COMMITTER_NAME=update.sh git commit -m "$msg"
