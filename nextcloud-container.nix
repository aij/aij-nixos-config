{ config, lib, pkgs, ... }: {
  containers.nextcloud = {
    ephemeral = true;
    autoStart = true;
    config = import ./nextcloud.nix;
    bindMounts = {
      "/var/lib/nextcloud" = { isReadOnly = false; hostPath = "/tank/srv/nextcloud/nextcloud/"; };
      "/var/lib/postgresql" = { isReadOnly = false; hostPath = "/tank/srv/nextcloud/postgresql/"; };
      "/srv/secrets/" = { isReadOnly = true; hostPath = "/tank/srv/nextcloud/secrets/"; };
    };
    # Startup can take extra long during upgrades. Default of 1min was
    # not enough for the upgrade from nextcloud30 -> nextcloud31
    timeoutStartSec = "30min";
  };
  networking.firewall.allowedTCPPorts = [ 80 443 ];

}

# References
# Declarative NixOS Containers: https://blog.beardhatcode.be/2020/12/Declarative-Nixos-Containers.html
