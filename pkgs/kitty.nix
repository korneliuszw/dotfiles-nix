{config, pkg, ...}:

{
  programs.kitty = {
    enable = true;
    theme = "Catppuccin-Mocha";
    font = {
      name = "FiraCode Nerd Font";
      size = 12;
    };
    extraConfig = ''
      confirm_os_window_close 0
      window_padding_width 5
    '';
  };
}
