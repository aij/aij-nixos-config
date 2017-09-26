{ config, pkgs, ... }:
{
  imports = [ ./standard.nix ];

  environment.systemPackages = with pkgs; [
     man-pages wdiff
     gnumake gcc scala jdk ack ag clang ocamlPackages.utop # jre
     dash zsh
     python python3
     #androidsdk
     rustc cargo
     sshfs-fuse
     nix-repl
  ];
} 
