{ config, pkgs, ... }:
{
  imports = [ ./zfs.nix ];
  boot.zfs.enableUnstable = true;
}
