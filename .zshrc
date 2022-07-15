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

mcd () { mkdir -p "$@" && cd "$@"; }

# git sauce
gs () { git status }
gd () { git diff }

# run prettier on modified files (pomf)
pomf () {
  git status --porcelain | cut -d" " -f3 | xargs -I{} prettier --write {};
}

# fixup a particular commit
# count the number of commits in branch and adds 1
NUMBER_OF_COMMITS=$(($git rev-list --count main...HEAD) + 1));
# Run it after git add 
fup () {
  git commit --fixup=$1;
  git rebase --interactive --autosquash HEAD~$NUMBER_OF_COMMITS;
}

w3 () {
  cd $HOME/go/src/walmart/c3po-chatbot-utterance-handlers;
  set -a && source .env && set +a;
}

wali () {
 cd $HOME/walmart/wali/data-wali-conversational-bff;
 set -a && source .env && set +a;
}

walifront () {
 cd $HOME/walmart/wali/data-wali-chatbot-web-client;
 set -a && source .env && set +a;
}
