{config, pkgs, ...}: {
  imports = [
    ./standard.nix
    ./sshd.nix
    ./hosts-home.nix
    # ./aij/profiles/miner.nix
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.network = {
    enable = true;
    ssh = {
      enable = true;
      port = 2222; # To prevent ssh from freaking out because a different host key is used.
      authorizedKeys = config.users.users.root.openssh.authorizedKeys.keys;
      # Generate on host via
      # mkdir -p 700 /root/secrets/initrd/ && ssh-keygen -t ed25519 -N "" -f /root/secrets/initrd/ssh_host_ed25519_key
      hostKeys = [ /root/secrets/initrd/ssh_host_ed25519_key ];
    };
  };

  services.openssh.enable = true;

  services.keybase.enable = true;
  services.kbfs.enable = true;

  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [
      "systemd"
    ];
  };

  networking.nameservers = [ "10.0.0.1" "8.8.8.8" "4.4.4.4" ];
  networking.useDHCP = false;

  environment.systemPackages = with pkgs; [
    megacli ncurses5
    freeipmi ipmitool ipmiutil
    # xmr-stak
    ((python3
      .withPackages(ps: with ps; [
        docker
        requests # docker package depends on requests
      ]))
      .overrideAttrs(oldAttrs: { meta.priority = -1000; })
    )

  ];
  nixpkgs.config.allowUnfree = true;

  virtualisation.docker.enable = true;
}
