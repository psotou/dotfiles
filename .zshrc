eval "$(starship init zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# initialize autocomplete
autoload -Uz compinit add-zsh-hook
compinit

# reload zsh config
alias reload!='RELOAD=1 source ~/.zshrc'

# filesystem aliases
alias la='ls -AlhF --group-directories-first'
alias l='ls -lhF --group-directories-first'
alias ..='cd ..'
alias ...='cd ../..'

# helper aliases
alias grep='grep --color=auto'
alias df='df -h'    # disk free, in Gigabytes, not bytes
alias du='du -h -c' # calculate disk usage for a folder

# other aliases
alias vim='nvim'

export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/go/bin

mcd () {
  mkdir -p "$@" && cd "$@";
}

gs () { git status }
gd () { git diff }
