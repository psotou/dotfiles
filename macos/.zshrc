eval "$(starship init zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# initialize autocomplete
autoload -Uz compinit add-zsh-hook
compinit

bindkey -e
bindkey '[C' forward-word
bindkey '[D' backward-word

autoload zmv
alias mmv='noglob zmv -W'

# Git
export PATH="/opt/homebrew/Cellar/git/2.?.?/bin:$PATH"
# LLVM
export PATH="/opt/homebrew/Cellar/llvm/17.?.?/bin:$PATH"
# MySQL
export PATH="/opt/homebrew/Cellar/mysql-client/8.?.?/bin:$PATH"

alias reload!='RELOAD=1 source ~/.zshrc'
alias l='ls -lhtF --color=always'
alias la='ls -alhF --color=always'
alias ..='cd ..'
alias vim='nvim'

alias grep='grep --color=always'
alias df='df -h'    # disk free, in Gigabytes, not bytes
alias du='du -h -c' # calculate disk usage for a folder
alias mkdir='mkdir -p'
# alias tmux='tmux -u'

mcd () { mkdir "$@" && cd "$@"; }

# git sauce
gs () { git status; }
gd () { git diff; }

# easy access to projects and other local development
# fcd () { cd $HOME/go/src/meli/fury/fury_$1*; }
fcd () { cd $HOME/services-sdk/go/fury_$1*; }
scd () { cd $HOME/services-sdk/go/fury_go-toolkit-$1*; }

setenv () {
  if [ -f .env ]; then
    echo "sourcing .env"
    set -a && source .env && set +a;
  else
    echo "sourcing .envrc"
    set -a && source .envrc && set +a;
  fi
}

# python stuff for venv management (this makes pre-commit work)
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"


# golang
export PATH="/Users/psoto/go/bin:$PATH"
export GOPRIVATE=github.com/mercadolibre/*,github.com/melisource/*,github.com/psoto_meli
export GONOSUMDB=github.com/mercadolibre/*,github.com/melisource/*,github.com/psoto_meli
export GOPROXY=https://go.artifacts.furycloud.io/
export GONOPROXY=https://go.artifacts.furycloud.io/

# clang
# otherwise it won't find header files
export SDKROOT=$(xcrun --sdk macosx --show-sdk-path)

# locale
export LANG="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

# # The following line is added by pre-commit
# export PATH="/opt/homebrew/bin:$PATH"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"
export RANGER_FURY_LOCATION=/Users/psoto/.fury #Added by Fury CLI
export RANGER_FURY_VENV_LOCATION=/Users/psoto/.fury/fury_venv #Added by Fury CLI

# Added by Fury CLI installation process
declare FURY_BIN_LOCATION="/Users/psoto/.fury/fury_venv/bin" # Added by Fury CLI installation process
export PATH="$PATH:$FURY_BIN_LOCATION" # Added by Fury CLI installation process
# Added by Fury CLI installation process
