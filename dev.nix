{ config, pkgs, ... }:
{
  imports = [ ./standard.nix ];

  environment.systemPackages = with pkgs; [
     man-pages
     gnumake gcc scala jdk python python3 ack clang ocamlPackages.utop # jre
     #androidsdk
     rustc cargo
     sshfs-fuse
  ];
} 
