{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../zfs.nix
    ../../desktop.nix
    ../../dev.nix
    ../../unstable.nix
    # ../../profiles/miner.nix
  ];

  networking.hostName = "tobati";
  #networking.hostId = "235d6160";
  networking.hostId = "a638cdd5";

  networking.hosts = (import ../../hosts-home.nix).networking.hosts;

  # dhcpcd is no longer configuring the DNS server without this :(
  services.resolved.enable = true;

  services.openssh.enable = true;

  services.xserver = {
    videoDrivers = [ "amdgpu" "modesetting" ];
    xrandrHeads = [
      { output = "HDMI-A-0";
        monitorConfig = ''
          Option "Primary" "true"
        ''; }
      { output = "DisplayPort-2";
        monitorConfig = ''
          Option "RightOf" "HDMI-A-0"
        ''; }
    ];
  };
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.memtest86.enable = true;
  boot.loader.grub.configurationLimit = 20;

  nixpkgs.config.allowUnfree = true;

  nix = {
    useSandbox = true;
    # Don't build big-parallel jobs locally
    systemFeatures =  [ "nixos-test" "benchmark" "kvm" ];
    distributedBuilds = true;
    buildMachines =
      let m = hostName: maxJobs: speedFactor: {
            hostName = hostName;
            maxJobs = maxJobs;
            speedFactor = speedFactor;
            sshUser = "bob";
            system = "x86_64-linux";
            supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
          }; in
        [(m "m0" 32 2.6)
         (m "m4" 32 1.8)
         (m "m5" 64 2.5)
         (m "m6" 64 2.4)];
  };

  system.stateVersion = "19.03"; # Did you read the comment?
}
