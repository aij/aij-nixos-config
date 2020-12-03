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
      { output = "DisplayPort-0";
        monitorConfig = ''
          Option "Primary" "true"
          # Size extracted from xrandr. This really shouldn't need to be configured.
          # Unfortunately, setting the size explicitly causes Xorg to
          # miscalculate double the DPI in one dimension and casuse Firefox
          # to render everything bigger than ideal.
          # DisplaySize 697 392
        ''; }
      { output = "DisplayPort-1";
        monitorConfig = ''
          Option "RightOf" "DisplayPort-0"
          # DisplaySize 697 392
        '';  }
    ];
  };
  # Enable SI support for W5000 with AMDGPU, per
  # https://wiki.archlinux.org/index.php/AMDGPU#Enable_Southern_Islands_(SI)_and_Sea_Islands_(CIK)_support
  boot.extraModprobeConfig = ''
    options amdgpu si_support=1
    options amdgpu cik_support=0
  '';

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
        [#(m "m0" 32 2.6)
         #(m "m4" 32 1.8)
         (m "m5" 64 2)
         (m "m6" 64 2)];
  };

  system.stateVersion = "19.03"; # Did you read the comment?
}
