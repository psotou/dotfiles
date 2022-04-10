eval "$(starship init zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

alias grep='grep --color=auto'
alias gls='gls --color=auto'
alias la='gls -AlhF --group-directories-first'
alias l='gls -lhF --group-directories-first'
alias vim='nvim'
alias go114='go1.14.15'
alias ..='cd ..'
alias wt='cd $HOME/go/src/walmart/'

export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/go/bin

source "$HOME/.vim/plugged/gruvbox/gruvbox_256palette_osx.sh"

autoload -Uz compinit && compinit

mcd () {
  mkdir -p "$@" && cd "$@";
}
