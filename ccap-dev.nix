{ config, pkgs, ... }:
{
  imports = [ ./dev.nix ];

  networking.firewall.allowedTCPPorts = [ 8080 ];

  environment.systemPackages = with pkgs; [
     # Packages needed for CCAP3 development
     nodejs-8_x yarn flow
     # purescript
     nodePackages.prettier
     groovy
     postgresql100
     ((python
       .withPackages(ps: with ps; [ lxml beautifulsoup4 ]))
       .overrideAttrs(oldAttrs: { meta.priority = -1000; })
     )
     ((python3
       .withPackages(ps: with ps; [ lxml beautifulsoup4 ]))
       .overrideAttrs(oldAttrs: { meta.priority = -1000; })
     )
     subversionClient
     jetbrains.idea-community
     google-chrome-beta remmina rdesktop
  ];

  # For request monitoring app.
  services.mongodb.enable = true;

  # For running IE in virtualbox.
  virtualisation.virtualbox.host.enable = true;
} 
