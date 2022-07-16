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
  };
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}

# References
# Declarative NixOS Containers: https://blog.beardhatcode.be/2020/12/Declarative-Nixos-Containers.html
