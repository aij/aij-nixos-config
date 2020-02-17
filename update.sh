#!/bin/sh

set -e -x

# TODO: Check repo cleanliness

#(cd unstable && git fetch)

# When using worktrees, this would just re-fetch the same repo, which
# shouldn't matter since we already have all the updates.
#(cd stable && git fetch)

function do_update () {
    cd $1
    # FIXME: This gets the wrong commit for the stable worktree.
    old=`git show-ref -s HEAD`
    git checkout $2
    # Make sure checkout didn't take us backwards
    git merge --ff-only $old
    git merge --ff-only origin/$2
    cd ..
}

#do_update unstable nixos-unstable
#do_update stable nixos-19.09-small

# Is this equivalent, or close enough?
git submodule update --remote

# Test that everything still builds
tests/machine-builds.sh

test -e ../home0.nix && nixops deploy --build-only
    
git add stable unstable
git commit -m 'Update nixpkgs'