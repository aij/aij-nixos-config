# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../standard.nix
      ../../stable.nix
      ../../sshd.nix
      ../../desktop.nix
      ../../dev.nix
      ../../zfs.nix
      ../../bluetooth.nix
    ];

  # Use the systemd-boot EFI boot loader.
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;

  boot = {
  kernelPackages = pkgs.linuxPackages_6_15;
  kernelParams = [
    "clk_ignore_unused"
    "pd_ignore_unused"
    # Limit to 31 GB memory to work around blue screen on first keystroke
    "mem=31G"
  ];
  # Do we still need this?
  kernelPatches = lib.optionals false [
    {
      name = "snapdragon-config";
      patch = null;
      extraConfig = ''
        TYPEC y
        PHY_QCOM_QMP y
        QCOM_CLK_RPM y
        MFD_QCOM_RPM y
        REGULATOR_QCOM_RPM y
        PHY_QCOM_QMP_PCIE y
        CLK_X1E80100_CAMCC y
      '';
    }
  ];
  loader = {
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot/efi";
    systemd-boot = {
      enable = true;
    };
    grub = {
      #enable = true;
      device = "nodev";
      efiSupport = true;
    };
  };
};

hardware = {
  deviceTree = {
    enable = true;
    name = "qcom/x1e78100-lenovo-thinkpad-t14s.dtb";
  };
  enableRedistributableFirmware = true;
  firmware = lib.optionals false [
    (
      let
        t14sPkgs = builtins.fetchTarball {
        #t14sPkgs = requireFile {
          name = "t14s_gen6_snapdragon_firmware.tar";
          url = "file:///root/extracted-firmware/t14s_gen6_snapdragon_firmware.tar";
          # Hash per nix-prefetch-url
          #sha256 = "0qffczslifbdqz1vj1349w7rn34p79prnsc5mflr7h8v4kbsnxpl";
          # Hash when using fetchTarball, I was surprised to find the hash matches
          # what ookhoi reported in
          # https://discourse.nixos.org/t/configuration-for-thinkpad-t14s-gen-6-snapdragon-x-elite-x1e-78-100/56389
          # even though I extracted the firmware independently and made no effort
          # to make the tarball hash reproducible yet.
          sha256 = "03vgfhq16q95fdh00mvqbprw1m84lhgk5x6jjj7m4f981vcnapha";
        };
      in
      pkgs.runCommandNoCC "t14s" { } ''
          mkdir -p $out/lib/firmware/qcom/x1e80100/LENOVO/
        cp -r ${t14sPkgs} $out/lib/firmware/qcom/x1e80100/LENOVO/21N1/
      ''
    )
  ];
};

networking = {
  wireless = {
    iwd = {
      enable = true;
      settings = {
        General = {
          ControlPortOverNL80211 = false;
        };
      };
    };
  };
};


  networking.hostName = "pirayu";
  networking.hostId = "f45ba803";
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;


  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.alice = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     tree
  #   ];
  # };

  # programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

  nixpkgs.overlays = [
    (self: super: {
      # The "linux-firmware: 20250410 -> 20250509" upgrade broke WiFI on ath12 (including Thinkpad T14s Gen6)
      # https://github.com/NixOS/nixpkgs/commit/d91d7cf3fdeeb7bbb33b53b9974170933d342e70
      # Upstream bug report https://bugzilla.kernel.org/show_bug.cgi?id=220108
      # https://discourse.nixos.org/t/configuration-for-thinkpad-t14s-gen-6-snapdragon-x-elite-x1e-78-100/56389/42?u=aij
      linux-firmware = super.linux-firmware.overrideAttrs (oldAttrs: {
        version = "20250410";
        src = pkgs.fetchzip {
          url = "https://cdn.kernel.org/pub/linux/kernel/firmware/linux-firmware-20250410.tar.xz ";
           hash = "sha256-aQdEl9+7zbNqWSII9hjRuPePvSfWVql5u5TIrGsa+Ao=";
        };
      });
    })
  ];

}

