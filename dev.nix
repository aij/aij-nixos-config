{ config, pkgs, ... }:
{
  imports = [ ./standard.nix ];

  programs.java.enable = true;

  environment.systemPackages = with pkgs; [
     man-pages wdiff
     gnumake gcc scala ack ag ocamlPackages.utop
     gdb
     rr
     inotifyTools watchexec
     (clang.overrideAttrs(oldAttrs: { meta.priority = -1; }))
     clang-tools
     jq yq
     sqlite-interactive
     rtags
     dash zsh
     dhall
     ghc
     # idris
     unison
     fstar
     ispell
     jbuilder
     nix-prefetch-git
     nix-index
     nixpkgs-fmt
     nox
     python
     python3
     ruby
     #androidsdk
     rustc cargo
     sshfs-fuse
     patdiff
     vagrant
     direnv
     ocamlPackages.merlin
     ocamlPackages.reason
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
