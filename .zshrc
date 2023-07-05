#!/usr/bin/env zsh
set -o vi
setopt autocd
eval "$(starship init zsh)"
source ${HOME}/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
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
