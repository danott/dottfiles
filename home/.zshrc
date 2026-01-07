# PATH
PATH="$PATH:$HOME/Code/dottfiles/bin"
export PATH

# Editor
export EDITOR=nvim

# Homebrew (platform-dependent)
test -d /opt/homebrew && eval "$(/opt/homebrew/bin/brew shellenv)"
test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)

# Prompt
eval "$(starship init zsh)"

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY

# Completion
autoload -U compinit && compinit

# rbenv
export RBENV_ROOT=$HOME/.rbenv
eval "$(rbenv init - zsh)"

# Planning Center
if [[ -f "$HOME/Code/pco/bin/pco" ]]; then
  eval "$($HOME/Code/pco/bin/pco init -)"
fi

if [[ -d "$HOME/pco-box" ]]; then
  source $HOME/pco-box/env.sh
  PATH="${PATH}:$HOME/pco-box/bin"
  export MYSQL_PORT_3306_TCP_ADDR=127.0.0.1
  export MYSQL_READER_PORT_3306_TCP_ADDR=127.0.0.1
  export MYSQL_READER_PORT_3306_TCP_PORT=3307
fi

# Local overrides
if [ -f "$HOME/.zshrc.local.zsh" ]; then
  source "$HOME/.zshrc.local.zsh"
fi

# autojump
[ -f $(brew --prefix)/etc/profile.d/autojump.sh ] && . $(brew --prefix)/etc/profile.d/autojump.sh

# Aliases
if command -v nvim &> /dev/null; then
  alias vim='nvim'
fi