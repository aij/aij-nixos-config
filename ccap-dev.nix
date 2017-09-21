{ config, pkgs, ... }:
{
  imports = [ ./dev.nix ];

  networking.firewall.allowedTCPPorts = [ 8080 ];

  environment.systemPackages = with pkgs; [
     # Packages needed for CCAP3 development
     nodejs yarn purescript
     postgresql
     (python.withPackages(ps: with ps; [ lxml beautifulsoup4 ]))
     google-chrome-beta remmina 
  ];
} 
