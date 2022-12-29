# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
      ./nvidia-gpu.nix
      ../desktop.nix
    ];
  #desktop.useWayland = true;
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ]; 
  boot.supportedFilesystems = [ "ntfs" ];
  fileSystems."/" =
    { device = "/dev/wired/god";
      fsType = "ext4";
      options = [ "noatime" "nodiratime" "discard" ];
    };

  fileSystems."/home" =
    { device = "/dev/wired/lain";
      fsType = "btrfs";
      options =  [ "ssd" ];
    };

  fileSystems."/boot" =
    { device = "/dev/nvme0n1p1";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/873edb5c-a032-467e-92b7-271778f26bc7"; }
    ];

  boot.initrd.luks.devices = {
     cryptroot = {
      device = "/dev/disk/by-uuid/dc783a8f-4cfb-44ab-8b54-b3d760f3d327";
	    preLVM = true;
	    allowDiscards = true;
     };
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = false;

  networking.interfaces.enp34s0.ipv4.addresses = [
    {
      address = "192.168.1.121";
      prefixLength = 24;
    }
  ];
  networking.defaultGateway = "192.168.1.1";
  networking.nameservers = ["1.1.1.1" "1.0.0.1"];
  networking.interfaces.enp34s0.useDHCP = false;
  networking.networkmanager = {
    #enable = true;
  };
  networking.wireless.enable = false;
  networking.hostName = "wired";

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;
  boot.loader = {
	efi = {
		canTouchEfiVariables = true;
		efiSysMountPoint = "/boot";
	};
	grub = {
		efiSupport = true;
		device = "nodev";
		version = 2;
		useOSProber = true;
	};
  };
  environment.systemPackages = with pkgs; [
     neovim
     wget
     curl
     git
     docker-compose
     via
     # Link sudo to doas
     #(pkgs.writeScriptBin "sudo" ''exec doas "$@"'')
   ];
}

