{ config, pkgs, nixpkgs, options, lib, ... }:
{
  imports = [ ./desktop.nix ];

  services.xserver.desktopManager.mate.enable = true;

  environment.systemPackages = with pkgs; [
    tuxtype
    tuxpaint
    gcompris
    prismlauncher
  ];
}
