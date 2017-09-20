{ config, pkgs, ... }:
{
  imports = [ ./dev.nix ];

  environment.systemPackages = with pkgs; [
     # Packages needed for CCAP3 development
     nodejs yarn postgresql
     (python.withPackages(ps: with ps; [ lxml beautifulsoup4 ]))
     google-chrome-beta remmina 
  ];
} 
