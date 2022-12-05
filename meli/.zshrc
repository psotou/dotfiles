eval "$(starship init zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# initialize autocomplete
autoload -Uz compinit add-zsh-hook
compinit

bindkey -e
bindkey '[C' forward-word
bindkey '[D' backward-word

# reload zsh config
alias reload!='RELOAD=1 source ~/.zshrc'

# filesystem aliases
alias ls='ls --color=auto'
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
# count the number of commits in branch and adds 1 for autosquash purposes
# since when we add a commit fixup we're adding one more commit
NUMBER_OF_COMMITS=$(($(git rev-list --count main...HEAD) + 1));
# run it after git add 
gfup () {
  git commit --fixup=$1;
  git rebase --interactive --autosquash HEAD~$NUMBER_OF_COMMITS;
}
