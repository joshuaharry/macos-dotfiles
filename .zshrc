#!/usr/bin/env zsh
set -o vi
setopt autocd
# setopt PROMPT_SUBST

# prompt_message() { 
#   printf "%s@%s$ " "$(basename "$(pwd)")" "$(git rev-parse --abbrev-ref HEAD 2>/dev/null || printf "(none)") " 
# }

# export PS1='$(prompt_message)'
source ${HOME}/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ${HOME}/.zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source ${HOME}/.agkozak-zsh-prompt/agkozak-zsh-prompt.plugin.zsh
source ${HOME}/.aliases.sh
eval "$(direnv hook zsh)"


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
