eval "$(starship init zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# initialize autocomplete
autoload -Uz compinit add-zsh-hook
compinit

# reload zsh config
alias reload!='RELOAD=1 source ~/.zshrc'

# filesystem aliases
alias gls='gls --color=auto'
alias la='gls -AlhF --group-directories-first'
alias l='gls -lhF --group-directories-first'
alias ..='cd ..'
alias ...='cd ../..'

# helper aliases
alias grep='grep --color=auto'
alias df='df -h'    # disk free, in Gigabytes, not bytes
alias du='du -h -c' # calculate disk usage for a folder

# other aliases
alias vim='nvim'
alias notes='cd $HOME/Documents/walmart/notes/'

export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/go/bin

source "$HOME/.vim/plugged/gruvbox/gruvbox_256palette_osx.sh"

mcd () {
  mkdir -p "$@" && cd "$@";
}

gs () { git status }
gd () { git diff }

w3 () {
  cd $HOME/go/src/walmart/c3po-chatbot-utterance-handlers;
  set -a && source .env && set +a;
}
