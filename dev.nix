{ config, pkgs, lib, ... }:
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
    fq
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
    semgrep
    shellcheck
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
    # rnix-lsp # Removed to avoid dependency on vulnerable nix-2.15.3 (CVE-2024-27297)
    python3
    mypy # TODO: pytype and/or pyre?
    black
    black-macchiato
    # python39Packages.isort # broken in unstable
    ruff # python linter / formatter
    # TODO: ssort? From https://github.com/bwhmather/ssort
    ruby
    #androidsdk
    android-tools
    rustc
    cargo
    rust-analyzer
    sshfs-fuse
    patdiff
    diffoscope
    # vagrant # Broken in nixos-unstable. https://github.com/NixOS/nixpkgs/issues/211153
    direnv
    ocamlPackages.merlin
    ocamlformat
    # ocamlPackages.reason
    # nodePackages_10_x.ocaml-language-server # Only in nixos-unstable
    smlnj
    coursier # scalafmt # scalafix
    bloop
    mercurial
    kubectl
    kubernix
    qemu
    vde2
    # Customized emacs package
    #(import pkg/emacs.nix { inherit pkgs; })
    emacs29
  ];

  virtualisation.podman.enable = true;
  virtualisation.virtualbox.host.enable = true;

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "androidsdk"
    "tools" # android-tools
  ];
}
