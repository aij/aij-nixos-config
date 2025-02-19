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

# Update flake.lock to match
# Use nix build from https://github.com/NixOS/nix/pull/12107 to work around regression of https://github.com/NixOS/nix/issues/9708
/nix/store/bn0djaymav6qa4zg5vaskzcaija5nq2p-nix-2.26.0pre20241227_9111645/bin/nix flake update

# Test that everything still builds
tests/machine-builds.sh

# Test colmena can still build my configuration with new submodules
test -e ../hive.nix && {
    nix-shell -p colmena --run 'cd .. && colmena apply build'
}
    
git add stable unstable flake.lock
GIT_AUTHOR_NAME=update.sh GIT_COMMITTER_NAME=update.sh git commit -m 'Update nixpkgs'
