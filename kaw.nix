{ config, pkgs, inputs, lib, ... }:
{
  services.syncthing.enable = true;
  programs.zsh.enable = true;
  home.stateVersion = "22.11";
  programs.chromium.extensions = [
        "gcbommkclmclpchllfjekcdonpmejbdp"
        "cjpalhdlnbpafiamejdnhcphjbkeiagm"
        "ogfcmafjalglgifnmanfmnieipoejdcf"
        "njdfdhgcmkocbgbhcioffdbicglldapd"
        "eimadpbcbfnmbkopoojfekhnkhdbieeh"
        "mnjggcdmjocbbbhaepdhchncahnbgone"
    ];
  imports = [
    inputs.nix-doom-emacs.hmModule
    inputs.webcord.homeManagerModules.default
    ./pkgs/vim.nix
    ./pkgs/zsh.nix
    ./pkgs/tmux.nix
    ./pkgs/emacs.nix
    ./pkgs/webcord.nix
    ./pkgs/kitty.nix
  ];
  home.username = "kaw";
  home.homeDirectory = "/home/kaw";
  home.packages = with pkgs; [
    ungoogled-chromium
    pkgs.unstable.mpv
    discord
    zathura
    zsh
    keepassxc
    thunderbird
    tor-browser-bundle-bin
    ncmpcpp
    spotify
    pkgs.unstable.wezterm
    home-manager
    pulsemixer
    pulseaudio
    pkgs.unstable.eww-wayland
    wl-clipboard
    bemenu
    fzf
    qt5ct
    socat
    mpd-mpris
    playerctl
    grim
    slurp
    pkgs.unstable.hyprpaper
    p7zip
    python38
    gnome.gnome-keyring
    texlive.combined.scheme-medium
    xdg-utils
    ripgrep
    ark
    unstable.latte-dock
    ocs-url
    rnix-lsp
    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = with vscode-extensions; [
        mkhl.direnv
        jnoortheen.nix-ide
        vscodevim.vim
        catppuccin.catppuccin-vsc
        arrterian.nix-env-selector
        bradlc.vscode-tailwindcss
        eamodio.gitlens
        cweijan.vscode-database-client2
        svelte.svelte-vscode
      ];
    })
  ];
  services.mpd.musicDirectory = "/home/kaw/Music";
  gtk = {
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
}
