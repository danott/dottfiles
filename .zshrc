#!/bin/zsh

# Reset PATH when reloading
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export DOTTFILES="$HOME/.dottfiles"

# Store secure environment variables in an uncommitted file
source ~/.secrets.zsh

export EDITOR=vim
export PATH="$HOME/bin:$DOTTFILES/bin:$PATH"

# Setup rbenv
# if command -v rbenv &>/dev/null; then
eval "$(rbenv init -)"
# fi
#
# Setup nodenv
eval "$(nodenv init -)"

# Setup autojump
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

# Setup completions
autoload -Uz compinit && compinit
fpath=(/usr/local/share/zsh-completions $fpath)


# ALIASES

alias gca="git commit -a"
alias gco="git checkout"
alias gd="git difftool"
alias gl="git pull"
alias gp="git push"
alias gpu="git push-upstream"
alias gs="git status"
alias ios="open /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app"
alias reload="source $HOME/.profile"


# PROMPT
# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
export GIT_PS1_SHOWCOLORHINTS=1
source $DOTTFILES/sh/git-prompt.sh
precmd () { __git_ps1 "%n" ":%~$ " "|%s" }


# OSX DEFAULTS

# Limited Dark Mode
# defaults write -g NSRequiresAquaSystemAppearance -bool Yes # Limit to toolbar and dock
# defaults delete -g NSRequiresAquaSystemAppearance # Return to system default
export PATH=/Users/danott/pco-box/bin:/usr/local/bin:/usr/local/sbin:$PATH
eval "$(rbenv init -)"
