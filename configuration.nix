# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
      ./kaw.nix
    ];
  nixpkgs.overlays = [
      (import ./pkgs)
  ];
  # Use the systemd-boot EFI boot loader.
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
  boot.initrd.systemd.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_zen;
  nix.settings.cores = 14;
  networking.hostName = "wired";
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  networking.firewall.allowedTCPPorts = [ 57621 ];
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    #keyMap = "pl";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  # Enable the X11 windowing system.
  #services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl = {
  	enable = true;
	extraPackages = with pkgs; [
		vaapiVdpau
	];
  };
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.nvidia.powerManagement.enable = true;
  hardware.nvidia.modesetting.enable = true;
  # Enable the GNOME Desktop Environment.
  #services.xserver.displayManager.gdm.enable = false;
  #services.xserver.desktopManager.gnome.enable = false;

  # Configure keymap in X11
  services.xserver.layout = "pl";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  hardware.pulseaudio.enable = false;
  services.usbmuxd.enable = true;
  environment.systemPackages = with pkgs; [
     neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     curl
     git
     libimobiledevice
     ifuse
     # Link sudo to doas
     (pkgs.writeScriptBin "sudo" ''exec doas "$@"'')
   ];

  services.greetd = {
  	enable = true;
	settings = rec {
		initial_session = {
			command = "Hyprland";
			user = "kaw";
		};
		default_session = initial_session;
	};
  };
  environment.etc."greetd/environments".text = ''
  	Hyprland
  '';
  environment.sessionVariables = rec {
  	GBM_BACKEND="nvidia-drm";
	__GL_GSYNC_ALLOWED="0";
	__GL_VRR_ALLOWED="0";
	WLR_DRM_NO_ATOMIC="1";
	__GLX_VENDOR_LIBRARY_NAME="nvidia";
	QT_QPA_PLATFORM="wayland";
	GDK_BACKEND="wayland,x11";
	WLR_NO_HARDWARE_CURSORS="1";
	MOZ_ENABLE_WAYLAND="1";
	LIBVA_DRIVER_NAME="nvidia";
	CLUTTER_BACKEND="wayland";
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  security.doas.enable = true;
  security.sudo.enable = false;
  security.doas.extraRules = [{
  	groups = [ "wheel" ];
	keepEnv = true;
	persist = true;
  }];

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
  programs.dconf.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    fira-code
    fira-code-symbols
    proggyfonts
    (nerdfonts.override {
      fonts = [ "FiraCode" "DroidSansMono" ];
    })
  ];


}

