#!/usr/bin/env zsh
eval "$(/opt/homebrew/bin/brew shellenv)"
export N_PREFIX="$HOME/.n"
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"

export PATH="$HOME/bin:$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.pyenv/versions/3.11.3/bin:$HOME/.rbenv/shims:$HOME/.n/bin:/opt/homebrew/opt/openjdk@17/bin:/opt/homebrew/opt/llvm/bin:${PATH}"
