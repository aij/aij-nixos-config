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
     ocamlPackages.merlin nodePackages_10_x.ocaml-language-server
     ocamlPackages.reason
     coursier scalafmt scalafix
     # Customized emacs package
     (import pkg/emacs.nix { inherit pkgs; })
  ];

  virtualisation.virtualbox.host.enable = true;
}
