{ config, pkgs, ... }:
{
  imports = [ ./dev.nix ];

  networking.firewall.allowedTCPPorts = [ 8080 ];

  environment.systemPackages = with pkgs; [
     # Packages needed for CCAP3 development
     nodejs-8_x yarn purescript flow
     nodePackages.prettier
     postgresql
     ((python
       .withPackages(ps: with ps; [ lxml beautifulsoup4 ]))
       .overrideAttrs(oldAttrs: { meta.priority = -1000; })
     )
     subversionClient
     google-chrome-beta remmina rdesktop
  ];

  # For running IE in virtualbox.
  virtualisation.virtualbox.host.enable = true;
} 
