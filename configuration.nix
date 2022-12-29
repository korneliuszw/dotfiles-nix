# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  users.users.kaw = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "audio"
      "video"
      "docker"
    ];
    shell = pkgs.zsh;
  };
  # Use the systemd-boot EFI boot loader.
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.kernelPackages = pkgs.linuxPackages_zen;
  nix.settings.cores = 14;
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    #keyMap = "pl";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  # Configure keymap in X11
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  security.rtkit.enable = true;
  services.usbmuxd.enable = true;
  environment.systemPackages = with pkgs; [
     neovim
     wget
     curl
     git
     docker-compose
     # Link sudo to doas
     #(pkgs.writeScriptBin "sudo" ''exec doas "$@"'')
   ];
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  security.sudo.enable = true;
  system.stateVersion = "22.05"; # Set to first install version
  virtualisation.docker.enable = true;
}

