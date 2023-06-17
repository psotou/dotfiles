eval "$(starship init zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# initialize autocomplete
autoload -Uz compinit add-zsh-hook
compinit

bindkey -e
bindkey '[C' forward-word
bindkey '[D' backward-word

PATH=/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH
PATH=$PATH:/usr/local/go/bin
PATH=$PATH:$HOME/go/bin

# export TERM="xterm-256color"
export GOPRIVATE="github.com/mercadolibre"

# binutils
export PATH="/opt/homebrew/opt/binutils/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/binutils/lib"
export CPPFLAGS="-I/opt/homebrew/opt/binutils/include"


# helper aliases
alias reload!='RELOAD=1 source ~/.zshrc'
alias ls='ls --color=auto --group-directories-first'
alias la='ls -alhF'
alias lr='ls -alhR'
alias l='ls -lhF'
alias ..='cd ..'
alias ...='cd ../..'

alias grep='grep --color=auto'
alias df='df -h'    # disk free, in Gigabytes, not bytes
alias du='du -h -c' # calculate disk usage for a folder
alias vim='nvim'
alias bat='bat --paging=never --style=plain'
alias mkdir='mkdir -p'
alias tmux='tmux -u'

mcd () { mkdir "$@" && cd "$@"; }

# git sauce
gs () { git status; }
gd () { git diff; }

# easy access to projects and other local development
fcd () { cd $HOME/go/src/meli/fury/fury_$1*; }
notes () { cd $HOME/meli/notes/ }

setenv () {
  if [ -f .env ]; then
    echo "sourcing .env"
    set -a && source .env && set +a;
  else
    echo "sourcing .envrc"
    set -a && source .envrc && set +a;
  fi
}

# mysql
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"

## The following line is added by pre-commit
export PATH="/opt/homebrew/bin:$PATH"

# nordic-doctor
export NORDIC_DOCTOR_DIR="$HOME/.nordic-doctor"
export PATH="$NORDIC_DOCTOR_DIR/bin:$PATH"

# python stuff for venv management (this makes pre-commit work)
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export RANGER_FURY_LOCATION=/Users/psoto/.fury #Added by Fury CLI
export RANGER_FURY_VENV_LOCATION=/Users/psoto/.fury/fury_venv/ #Added by Fury CLI
# Added by Fury CLI installation process
declare FURY_BIN_LOCATION="/Users/psoto/.fury/fury_venv/bin" # Added by Fury CLI installation process
export PATH="$FURY_BIN_LOCATION:$PATH" # Added by Fury CLI installation process

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

