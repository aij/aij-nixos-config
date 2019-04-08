{ config, pkgs, ... }:
{
  imports = [ ./standard.nix ];

  programs.java.enable = true;

  environment.systemPackages = with pkgs; [
     man-pages wdiff
     gnumake gcc scala ack ag ocamlPackages.utop
     (clang.overrideAttrs(oldAttrs: { meta.priority = -1; }))
     dash zsh
     ghc
     idris
     ispell
     jbuilder
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
     coursier scalafmt # scalafix
     bloop
     vscode
     # Customized emacs package
     (import pkg/emacs.nix { inherit pkgs; })
  ];

  virtualisation.virtualbox.host.enable = true;
}
