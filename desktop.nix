{ config, pkgs, ...}:
let
  useWayland = config.desktop.useWayland;
in {
  options = {
    desktop.useWayland = lib.mkOption {
      type = lib.types.bool;
    }
  };

  programs.dconf.enable = true;

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
  sound.enable = true;
  services.xserver.layout = "pl";
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  hardware.pulseaudio.enable = false;

  imports = [
    (if useWayland then ./wayland.nix else ./xorg.nix)
  ];
  gtk = {
    enable = true;
    font = {
      name = "FiraCode Nerd Font";
      package = null;
      size = 12;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "Catppuccin";
      package = pkgs.catppuccin-gtk;
    };
  };
  qt.style.name = "gtk2";
  xdg.configFile."hypr" = {
    source = ./pkgs/hyprland;
    recursive = true;
  };
  services.mpd.enable = true;
}
