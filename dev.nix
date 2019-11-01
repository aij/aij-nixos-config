{ config, pkgs, ... }:
{
  imports = [ ./standard.nix ];

  programs.java.enable = true;

  environment.systemPackages = with pkgs; [
     man-pages wdiff
     gnumake gcc scala ack ag ocamlPackages.utop
     gdb
     inotifyTools watchexec
     (clang.overrideAttrs(oldAttrs: { meta.priority = -1; }))
     clang-tools
     rtags
     dash zsh
     dhall
     ghc
     # idris # Broken in nixos-unstable
     ispell
     jbuilder
     nix-prefetch-git
     nix-index
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
     # Customized emacs package
     #(import pkg/emacs.nix { inherit pkgs; })
     emacs
  ];

  virtualisation.virtualbox.host.enable = true;
}
