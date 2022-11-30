{
	programs.zsh = {
		enable = true;
		history.ignorePatterns = [ "pkill *" "kill *"];
		oh-my-zsh.enable = true;
		oh-my-zsh.plugins = ["git" "sudo" "cp" "extract" "timer" "rsync" "gitignore" "vi-mode"];
		oh-my-zsh.theme = "afowler";
		autocd = true;
		dotDir = ".config/zsh";
		dirHashes = {
			books = "$HOME/Books";
			movies = "$HOME/Movies";
			steamgames = "$HOME/.steam/steam/steamapps/common";
			dl = "$HOME/Downloads";
			projects = "$HOME/Programming/Projects";
		};
		enableCompletion = true;
		enableAutosuggestions = true;
		enableSyntaxHighlighting = true;
		sessionVariables = {
			EDITOR="nvim";
			PAGER="less";
			GOPATH="$HOME/go";
			DISABLE_MAGIC_FUNCTIONS="true"; # Not sure what this does but fixes osme isssues
			ENABLE_CORRECTION="true"; # Enable command correction (prompt)
			DISABLE_UNTRACKED_FILES_DIRTY="true"; # Don't mark changed untracked files
			HIST_STAMPS="dd/mm/yyyy"; # Timestamp format
			HYPHEN_INSENSITIVE="true"; # - or _ ? Doesn't matter!
			DISABLE_UPDATE_PROMPT="true";
			UPDATE_ZSH_DAYS="30";
			PATH="$HOME/.local/bin:$PATH";
			XDG_CONFIG_HOME="$HOME/.config";
			BROWSER="chromium";
		};
		shellAliases = {
			vim="nvim";
			ssh="TERM=vt100 ssh";
		};
	};
	programs.direnv = {
		enable = true;
		enableZshIntegration = true;
	};
	programs.fzf = {
		enable = true;
		enableZshIntegration = true;
	};
}
