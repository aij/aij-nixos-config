# NixOS module for tftp-hpa TFTP server

{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.services.tftp-hpa;

in

{

  options = {

    services.tftp-hpa = {

      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether to enable the tftp-hpa TFTP server. By default, the server
          binds to address 0.0.0.0 and serves from /srv/tftpd.
        '';
      };

      extraOptions = mkOption {
        default = [];
        type = types.listOf types.str;
        example = literalExample ''
          [ "--address 192.168.9.1"
            "--verbose"
          ]
        '';
        description = ''
          Extra command line arguments to pass to tftp-hpa in.tftpd.
        '';
      };

      root = mkOption {
        default = "/srv/tftp";
        type = types.path;
        description = ''
          Document root directory for tftp.
        '';
      };

    };

  };

  config = mkIf cfg.enable {

    systemd.services.tftp-hpa = {
      description = "TFTP Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      # runs as nobody
      serviceConfig.ExecStart = "${pkgs.tftp-hpa}/bin/in.tftpd --foreground --secure ${lib.concatStringsSep " " cfg.extraOptions} ${cfg.root}";
    };

  };

}
