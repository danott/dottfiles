# PATH
PATH="$PATH:$HOME/dottfiles/bin" # My scripts
PATH="$HOME/.local/bin:$PATH" # Claude Code native install
export PATH

# Editor
export EDITOR=nvim

# Homebrew (platform-dependent)
test -d /opt/homebrew && eval "$(/opt/homebrew/bin/brew shellenv)"
test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)

# Prompt
eval "$(starship init bash)"

# History
HISTSIZE=10000
HISTFILESIZE=10000
shopt -s histappend
PROMPT_COMMAND="history -a${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

# Completion
if [ -f "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]; then
  source "$(brew --prefix)/etc/profile.d/bash_completion.sh"
fi

# rbenv
export RBENV_ROOT=$HOME/.rbenv
eval "$(rbenv init - bash)"

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
if [ -f "$HOME/.bashrc.local" ]; then
  source "$HOME/.bashrc.local"
fi

# autojump
[ -f $(brew --prefix)/etc/profile.d/autojump.sh ] && . $(brew --prefix)/etc/profile.d/autojump.sh

# direnv
eval "$(direnv hook bash)"

# Aliases
if command -v nvim &> /dev/null; then
  alias vim='nvim'
fi

alias gco='git checkout'
alias gl='git pull'
alias gp='git push'
alias gca='git commit --all'

# tend — metabolic workspace
alias td='tend daily'
alias tdo='open $(tend --touch --print daily)'

alias tsv='tend scratch'
alias tso='open $(tend --touch --print scratch)'

alias tj='tend journal'
alias tjo='open $(tend --touch --print journal)'

alias tc='tend capture'
alias tco='open $(tend --touch --print capture)'

alias ti='cd $(tend --print inbox)'
alias tio='open $(tend --print inbox)'

alias tn='cd $(tend --print now)'
alias tno='open $(tend --print now)'

alias tci='tend-check-in'
alias tcil='tend-check-in --loop'

# Require explicit CLAUDE_CONFIG_DIR selection
claude() {
  if [ -z "$CLAUDE_CONFIG_DIR" ]; then
    echo "CLAUDE_CONFIG_DIR is not set. Pick an environment:" >&2
    local envs=("$HOME/.claude_config_dirs"/*)
    select dir in "${envs[@]##*/}"; do
      if [ -n "$dir" ]; then
        CLAUDE_CONFIG_DIR="$HOME/.claude_config_dirs/$dir" command claude "$@"
        return
      fi
    done
    return 1
  fi
  command claude "$@"
}

# https://pages.tobi.lutke.com/try/#install
if command -v try &> /dev/null; then
  eval "$(try init)"
fi
