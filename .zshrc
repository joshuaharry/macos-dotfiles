#!/usr/bin/env zsh
set -o vi
setopt autocd
eval "$(starship init zsh)"
source ${HOME}/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ${HOME}/.aliases.sh