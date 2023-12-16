# Include via nextcloud-container.nix to run NextCloud in a container
{ config, lib, pkgs, ... }: {

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud26;
    hostName = "nextcloud.mrph.org";
    config = {
      extraTrustedDomains = [
        "m2.mrph.org.beta.tailscale.net"
        # "m2"
      ];
      dbtype = "pgsql";
      dbuser = "nextcloud";
      dbhost = "/run/postgresql"; # nextcloud will add /.s.PGSQL.5432 by itself
      dbname = "nextcloud";
      adminpassFile = "/srv/secrets/adminpass";
      adminuser = "root";
    };
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "nextcloud" ];
    ensureUsers = [
      {
        name = "nextcloud";
        ensurePermissions."DATABASE nextcloud" = "ALL PRIVILEGES";
      }
    ];
  };

  # ensure that postgres is running *before* running the setup
  systemd.services."nextcloud-setup" = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };

  system.stateVersion = "22.11";
}
