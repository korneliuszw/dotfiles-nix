{
	programs.tmux = {
		enable = true;
		keyMode = "vi";
		newSession = true;
		extraConfig = ''
		  set -g mouse on
		'';
		tmuxinator.enable = true;
		shortcut = "Space";
	};
}
