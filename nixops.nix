{config, pkgs, ...}: {
  imports = [
    ./standard.nix
    ./sshd.nix
    (import ./hosts-home.nix).networking.interfaces
    # ./aij/profiles/miner.nix
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.openssh.enable = true;

  services.keybase.enable = true;
  services.kbfs.enable = true;

  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [
      "systemd"
    ];
  };

  networking.hosts = (import ./hosts-home.nix).networking.hosts;

  networking.nameservers = [ "10.0.0.1" "8.8.8.8" "4.4.4.4" ];

  environment.systemPackages = with pkgs; [
    megacli ncurses5
    freeipmi ipmitool ipmiutil
    xmr-stak
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
