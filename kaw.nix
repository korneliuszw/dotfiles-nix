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
    ./pkgs/spotify.nix
  ];
  home.sessionVariables = {
    XDG_DATA_DIRS= with pkgs;"${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:\${XDG_DATA_DIRS}";
  };
  home.username = "kaw";
  home.homeDirectory = "/home/kaw";
  home.packages = with pkgs; [
    cider
    ungoogled-chromium
    pkgs.unstable.mpv
    discord
    zathura
    zsh
    keepassxc
    thunderbird
    tor-browser-bundle-bin
    ncmpcpp
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
    p7zip
    python38
    gnome.gnome-keyring
    texlive.combined.scheme-full
    xdg-utils
    ripgrep
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
        prisma.prisma
        ms-python.python
        pkgs.unstable.vscode-extensions.astro-build.astro-vscode
        vscode-extensions.matklad.rust-analyzer
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "vscode-thunder-client";
          publisher = "rangav";
          version = "2.2.4";
          sha256 = "642cbd549dc86dd6d1071956ffab5051c637152231e11a9943eb4bd475a9709d";
        }
        {
          name = "tauri-vscode";
          publisher = "tauri-apps";
          version = "0.2.1";
          sha256 = "707fc3843da8a4b96592b6ad7516f1fcc70527edbc62645de840ae711c1daf78";
        }
      ];
    })
  ];
  services.mpd.musicDirectory = "/home/kaw/Music";
  services.mpd.enable = true;
  services.mpd.extraConfig = ''
    audio_output {
      type "pipewire"
      name "Pipewire Output 1"
    }
  '';
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
  services.gnome-keyring.enable = true;
}
