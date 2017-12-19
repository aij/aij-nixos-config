{ pkgs, ...}: let
  cfg = {
    extraConfig =
      ''
        LATENCYTOP y
        SCHEDSTATS y
      '';
  };
in {

  nixpkgs.config.packageOverrides = pkgs: {
    # It would be nice if this wasn't version-specific
    linux_4_9 = pkgs.linux_4_9.override cfg;
    # For use with boot.kernelPackages = pkgs.linuxPackages_latest
    linux_latest = pkgs.linux_latest.override cfg;
  };

  environment.systemPackages = [ pkgs.latencytop ];
}
