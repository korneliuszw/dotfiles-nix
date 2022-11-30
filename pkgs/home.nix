{ config, pkgs, ... }:
let
  pkgsUnstable = import <nixpkgs-unstable> {};
in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  nixpkgs.config.allowUnfree = true;
  home.username = "kaw";
  home.homeDirectory = "/home/kaw";
  home.packages = with pkgs; [
    ungoogled-chromium
    mpv
    discord
    zathura
    zsh
    keepassxc
    thunderbird
    tor-browser-bundle-bin
    ncmpcpp
    spotify
    pkgsUnstable.wezterm
  ];
  services.mpd.enable = true;
  services.mpd.musicDirectory = "/home/kaw/Music";
 # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.chromium.extensions = [
    "gcbommkclmclpchllfjekcdonpmejbdp"
    "cjpalhdlnbpafiamejdnhcphjbkeiagm"
    "ogfcmafjalglgifnmanfmnieipoejdcf"
    "njdfdhgcmkocbgbhcioffdbicglldapd"
    "eimadpbcbfnmbkopoojfekhnkhdbieeh"
    "mnjggcdmjocbbbhaepdhchncahnbgone"
  ];

  imports = [
  ./zsh.nix
  ./tmux.nix
  ./vim.nix
  ./emacs.nix
  ./hyprland.nix
  ./webcord.nix
  ./wezterm.nix
  ];
  
}
