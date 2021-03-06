{ pkgs, lib, suites, config, ... }:
let ip = "192.168.1.11";
in
{
  imports = suites.themachine ++ [ ../../profiles/graphical/games ];

  networking = {
    usePredictableInterfaceNames = false;
    wireless.enable = false;
    interfaces."eth0".ipv4.addresses = [
      {
        address = ip;
        prefixLength = 16;
      }
    ];
#    useDHCP = false;
    defaultGateway = "192.168.1.1";
  };

  services.fwupd.enable = true;
  services.fstrim.enable = true;

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;

  security.mitigations.acceptRisk = true;

  nix.maxJobs = 12;

  i18n.defaultLocale = "en_US.UTF-8";
#  time.timeZone = "Asia/Ho_Chi_Minh";

  nixpkgs.overlays =
    let
      nmap_ov = final: prev: {
        nmap = prev.nmap.overrideAttrs (_: {
          postPatch = ''
            substituteInPlace nselib/rtsp.lua \
              --replace table.unpack "\"\", --- "
          '';
        });
      };
    in
    [ nmap_ov ];

  boot = {
#    binfmt.emulatedSystems = [ "aarch64-linux" ];
#    tmpOnTmpfs = true;
#    kernelPackages = pkgs.linuxPackages_5_12;

#    initrd.availableKernelModules = [
#      "amdgpu"
#      "ahci"
#      "xhci_pci"
#      "nvme"
#      "uas"
#      "usb_storage"
#      "usbhid"
#      "sd_mod"
#      "kvm-amd"
#      "v4l2loopback"
#      "snd_aloop"
#    ];
#    kernelModules = config.boot.initrd.availableKernelModules;
#    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];

#    extraModprobeConfig = ''
#      options v4l2loopback exclusive_caps=1 video_nr=9 card_label="OBS"
#    '';

#    initrd.supportedFilesystems = [ "btrfs" ];
#    supportedFilesystems = [ "btrfs" "ntfs" ];

#    loader = {
#      timeout = 1;
#      systemd-boot.enable = true;
#      systemd-boot.memtest86.enable = true;
#      systemd-boot.configurationLimit = 5;
#      systemd-boot.consoleMode = "max";
#      efi.canTouchEfiVariables = true;
#    };

    plymouth = {
      enable = true;
      theme = "breeze";
      themePackages = with pkgs; [ libsForQt5.breeze-plymouth ];
      # theme = "hexagon_dots_alt"; # "connect";
      # themePackages = [ (pkgs.plymouth-themes.override { inherit (config.boot.plymouth) theme; }) ];
    };

#    persistence.path = "/persist";
  };

#  services.btrfs.autoScrub = {
#    enable = true;
#    fileSystems = [ "/mnt/cubum" "/mnt/danie" "/persist" ];
#  };

#  fileSystems = {
#    "/boot" = {
#      device = "/dev/disk/by-label/EFI";
#      fsType = "vfat";
#    };
#    "/mnt/cubum" = {
#      device = "/dev/disk/by-label/dandrive";
#      fsType = "btrfs";
#      options = [ "subvol=cubum" "compress=zstd" "nossd" ];
#    };
#    "/mnt/danie" = {
#      device = "/dev/disk/by-label/dandrive";
#      fsType = "btrfs";
#      options = [ "subvol=danie" "compress=zstd" "nossd" ];
#    };
 #   "/persist" = {
 #     device = "/dev/mapper/system";
#      fsType = "btrfs";
#      options = [ "subvol=persist" "compress=zstd" "noatime" ];
#    };
#  };

#  swapDevices =
#    [{
#      device = "/dev/disk/by-partuuid/90abac81-a5e9-4506-9fe5-a2c69500efd5";
#      randomEncryption.enable = true;
#    }];


#        networking.hostName = "itshaydencmp";
        networking.firewall.enable = lib.mkForce true;
        networking.networkmanager.enable = true;
        networking.useDHCP = false;
        networking.interfaces.enp0s31f6.useDHCP = true;
        networking.interfaces.wlp4s0.useDHCP = true;
        boot.cleanTmpDir = true;
        boot.tmpOnTmpfs = true;
        boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ "kvm-amd" ];
        boot.extraModulePackages = [ ];
        boot.loader.grub.devices = ["/dev/nvme0n1"];
    #    boot.loader.systemd-boot.enable = true;
    #    boot.loader.efi.canTouchEfiVariables = true;
    #    boot.zfs.requestEncryptionCredentials = true;
    #    boot.supportedFilesystems = ["zfs"];
    #    services.zfs.autoSnapshot.enable = true;
    #    services.zfs.autoScrub.enable = true;
        time.timeZone = "US/Pacific";
        networking.hostId = "a3c04b60";


  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

        fileSystems."/" =
          {
          device = "rtank/root/nixos";
          # device = "/dev/disk/by-uuid/nvme-SAMSUNG_MZVLB256HAHQ-000L7_S41GNX0N131513-part4";
          fsType = "zfs";
        };

        fileSystems."/boot" =
          { device = "/dev/disk/by-uuid/F41A-B69B";
          fsType = "vfat";
        };

        fileSystems."/home" =
        {
        device = "rtank/home";
      fsType = "zfs";
        };

        swapDevices = [ { device = "/dev/disk/by-uuid/ce69d716-5608-4e1c-8620-f15e4f71f91c"; } ];

}
