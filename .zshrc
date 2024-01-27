#!/usr/bin/env zsh
set -o vi
setopt autocd
setopt PROMPT_SUBST
source ${HOME}/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ${HOME}/.zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source ${HOME}/.aliases.sh
eval "$(direnv hook zsh)"

prompt_message() { 
  printf "\033[1;35m\033[1m%s\033[0m@\033[0;32m\033[1m%s\033[0m$ " "$(basename "$(pwd)")" "$(git rev-parse --abbrev-ref HEAD 2>/dev/null || printf "(none)") " 
}
export PS1='$(prompt_message)'

function man() {
	env \
		LESS_TERMCAP_md=$(tput bold; tput setaf 4) \
		LESS_TERMCAP_me=$(tput sgr0) \
		LESS_TERMCAP_mb=$(tput blink) \
		LESS_TERMCAP_us=$(tput setaf 2) \
		LESS_TERMCAP_ue=$(tput sgr0) \
		LESS_TERMCAP_so=$(tput smso) \
		LESS_TERMCAP_se=$(tput rmso) \
		PAGER="${commands[less]:-$PAGER}" \
		man "$@"
}
if [ "$TERM_PROGRAM" = "iTerm.app" ]; then
  gp
fi
