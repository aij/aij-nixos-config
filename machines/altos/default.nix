# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../desktop.nix
      ../../ccap-dev.nix
      ../../ccap-env.nix
      ../../latencytop.nix
    ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    memtest86.enable = true;
  };

  boot.initrd.luks.devices."nixcrypt" = {
     device = "/dev/disk/by-uuid/80687aab-261a-4ca9-aeec-6830df3308de";
  };

  networking.hostName = "altos";
  networking.hostId = "8425e349";
  networking.interfaces.enp0s31f6.ipv4.addresses = [{ address = "165.219.91.75"; prefixLength = 22; }];
  networking.defaultGateway = "165.219.90.3";
  networking.nameservers = [ "165.219.91.41" "165.219.91.42" ];
  # Hack for CCAP3
  networking.extraHosts = ''
    127.0.1.1	altos.wicourts.gov altos
  '';

  nix.buildCores = 0;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    stress stress-ng
    nixops
  ];
  nixpkgs.config.allowUnfree = true;

  # List services that you want to enable:

  #services.openssh.enable = true;

  services.prometheus = {
    exporters.node.enable = true;
    enable = true;
    scrapeConfigs =
      let hosts = ["localhost"]; in
      [
	{
	  job_name = "prometheus";
	  static_configs = [{targets = map (h: h + ":9090") hosts;}];
	}
	{
	  job_name = "node";
	  static_configs = [{targets = map (h: h + ":9100") hosts;}];
	}
        {
          job_name = "jmx";
          scrape_interval = "10s";
          static_configs = [{targets = ["localhost:1234" "localhost:1235"];}];
        }
      ];
  };
  services.grafana.enable = true;

  # Right-hand monitor is vertical, left (primary) is "normal"
  services.xserver.xrandrHeads = [
    { output = "DP2";
      monitorConfig = ''
       Option "PreferredMode" "1920x1080"
    ''; }
    { output = "HDMI2";
      monitorConfig = ''
       Option "Rotate" "left"
       Option "PreferredMode" "1920x1080" # Hack: Adding the above rotation causes the default mode to be wrong, so set it explicitly.
      ''; }
  ];

  # CCAP CIFS mounts
  fileSystems = let
    cifs = src: dst: {
      fsType = "cifs";
      device = src;
      mountPoint = dst;
      options = ["credentials=/home/aij/.smbcredentials,iocharset=utf8,gid=1001,uid=1001,file_mode=0644,dir_mode=0755"];
      noCheck = true; # No fsck for cifs.
    };
  in {
    H = cifs "//ccap-rds-1/user/staff/ijager" "/media/H";
    M = cifs "//ccap-rds-1/user/data" "/media/M";
    J = cifs "//ccap-rds-1/apps/Java" "/media/J";
    U = cifs "//ccap-rds-1/user" "/media/U";
  };


  nix.useSandbox = true;

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";

}
