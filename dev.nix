{ config, pkgs, ... }:
{
  imports = [ ./standard.nix ];

  environment.systemPackages = with pkgs; [
     man-pages wdiff
     gnumake gcc scala jdk ack ag ocamlPackages.utop # jre
     (clang.overrideAttrs(oldAttrs: { meta.priority = -1; }))
     dash zsh
     python
     python3
     ruby
     #androidsdk
     rustc cargo
     sshfs-fuse
     nix-repl
  ];
} 
