{ pkgs, ... }:

let
  doom-emacs = pkgs.callPackage (builtins.fetchTarball {
    url = https://github.com/nix-community/nix-doom-emacs/archive/master.tar.gz;
  }) {
    doomPrivateDir = ./doom.d;  # Directory containing your config.el init.el
                                # and packages.el files

   # dependencyOverrides = {
   #   "emacs-overlay" = (builtins.fetchTarball {
   #       url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
   #     });
   # };
   # emacsPackagesOverlay = self: super: {
   #   gitignore-mode = pkgs.emacsPackages.git-modes;
   #   gitconfig-mode = pkgs.emacsPackages.git-modes;
   # };
};
in {
  home.packages = [ doom-emacs ];
  #home.file.".emacs.d/init.el".text = ''
  #    (load "default.el")
  #'';
  services.emacs = {
    enable = true;
    package = doom-emacs;
  };
}
