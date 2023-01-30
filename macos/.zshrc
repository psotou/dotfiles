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
# Added by furycli:
export PATH="$HOME/Library/Python/3.9/bin:$PATH"
# PATH="$HOME/Library/Python/3.9/bin:$PATH"
export GOPRIVATE="github.com/mercadolibre"

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

mcd () { mkdir -p "$@" && cd "$@"; }

# git sauce
gs () { git status; }
gd () { git diff; }

# # run prettier on modified files (pomf)
# pomf () {
#   git status --porcelain | cut -d" " -f3 | xargs -I{} prettier --write {};
# }

# fixup a particular commit
# count the number of commits in branch and adds 1 for autosquash purposes
# since when we add a commit fixup we're adding one more commit.
# Run it after git add
gfup () {
  git commit --fixup=$1;
  git rebase --interactive --autosquash HEAD~$(($(git rev-list --count main...HEAD) + 1));
}

# easy access to projects and other local development
golocal () { cd $HOME/go/src/meli/local/ }
gofury () { cd $HOME/go/src/meli/fury/ }
notes () { cd $HOME/meli/notes/ }
eval "$(pyenv init --path)"
