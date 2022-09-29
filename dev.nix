{ config, pkgs, ... }:
{
  imports = [ ./standard.nix ];

  programs.java.enable = true;

  environment.systemPackages = with pkgs; [
    man-pages
    wdiff
    gnumake
    gcc
    scala
    ocamlPackages.utop
    gdb
    rr
    heaptrack
    inotify-tools
    watchexec
    (clang.overrideAttrs (oldAttrs: { meta.priority = -1; }))
    clang-tools
    bear # Generates compile_commands.json for clang tools
    jq
    yq
    sqlite-interactive
    gitAndTools.hub
    gitAndTools.lab
    gitAndTools.gh
    # gitAndTools.glab
    cloc
    dash
    zsh
    dhall
    ghc
    # idris
    unison
    fstar
    ispell
    dune_1
    nix-prefetch-git
    nix-index
    nixpkgs-fmt
    nixos-generators # For nixos-generate
    nox
    rnix-lsp
    python
    python3
    mypy # TODO: pytype and/or pyre?
    black
    black-macchiato
    python39Packages.isort
    # TODO: ssort? From https://github.com/bwhmather/ssort
    ruby
    #androidsdk
    rustc
    cargo
    rust-analyzer
    sshfs-fuse
    patdiff
    diffoscope
    vagrant
    direnv
    ocamlPackages.merlin
    # ocamlPackages.reason
    # nodePackages_10_x.ocaml-language-server # Only in nixos-unstable
    coursier # scalafmt # scalafix
    bloop
    mercurial
    kubectl
    kubernix
    qemu
    vde2
    # Customized emacs package
    #(import pkg/emacs.nix { inherit pkgs; })
    emacs
  ];

  virtualisation.podman.enable = true;
  virtualisation.virtualbox.host.enable = true;
}
