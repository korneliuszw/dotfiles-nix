{ config, pkgs, ... }:
let
  pkgsUnstable = import <nixpkgs-unstable> {};
  thunarC = with pkgs.xfce; thunar.override {
      thunarPlugins = [
        thunar-archive-plugin
        thunar-volman
      ];
    };
in {
imports = [
  <home-manager/nixos>
];
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
services.syncthing = {
  enable = true;
  user = "kaw";
  group = "users";
  dataDir = "/home/kaw";
  openDefaultPorts = true;
  configDir = "/home/kaw/.config/syncthing";
  overrideDevices = true;
  overrideFolders = true;
  devices = {
    "thinkpad" = { id = "GDKKIU5-4FNX3D7-OFCSMQU-QSEUR3T-KEHSH23-4B57U2U-ZQQYDOM-KCHLGQP"; };
  };
  folders = {
    "Writing" = {
      path = "/home/kaw/Writing";
      devices = [ "thinkpad" ];
    };
  };
};
programs.zsh.enable = true;
home-manager.users.kaw = { pkgs, ...}: {
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
    ./pkgs/vim.nix
    ./pkgs/zsh.nix
    ./pkgs/tmux.nix
    ./pkgs/emacs.nix
    ./pkgs/webcord.nix
    ./pkgs/kitty.nix
  ];
  nixpkgs.config.allowUnfree = true;
  home.username = "kaw";
  home.homeDirectory = "/home/kaw";
  home.packages = with pkgs; [
    ungoogled-chromium
    pkgsUnstable.mpv
    discord
    zathura
    zsh
    keepassxc
    thunderbird
    tor-browser-bundle-bin
    ncmpcpp
    spotify
    pkgsUnstable.wezterm
    home-manager
    pulsemixer
    pulseaudio
    pkgsUnstable.eww-wayland
    wl-clipboard
    bemenu
    fzf
    qt5ct
    socat
    mpd-mpris
    playerctl
    grim
    slurp
    pkgsUnstable.hyprpaper
    p7zip
    thunarC
    python38
    gnome.gnome-keyring
    texlive.combined.scheme-medium
    xdg-utils
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        bbenoist.nix
        vscodevim.vim
        catppuccin.catppuccin-vsc
        arrterian.nix-env-selector
        bradlc.vscode-tailwindcss
        eamodio.gitlens
        cweijan.vscode-database-client2
      ];
    })
  ];
  services.mpd.musicDirectory = "/home/kaw/Music";
};
}
