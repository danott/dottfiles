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

# direnv
eval "$(direnv hook zsh)"

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

# History search with arrow keys
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

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

# Ghostty/tmux/Hammerspoon integration: non-tmux window focus tracking.
# When a Ghostty window running a plain shell gets focus, write this window's
# TTY to ghostty-focused-window. tmux writes to BOTH files on its focus events;
# plain shells write only to ghostty-focused-window. Hammerspoon detects the
# mismatch between the two files and passes Cmd+keys through instead of
# routing them to tmux. Only active when NOT inside tmux (-z "$TMUX").
if [[ -n "$GHOSTTY_RESOURCES_DIR" && -z "$TMUX" ]]; then
  function _terminal_focus_in() {
    echo "$TTY" > /tmp/ghostty-focused-window
  }

  function _enable_focus_reporting() {
    printf '\033[?1004h'
  }

  zle -N _terminal_focus_in
  zle -N zle-line-init _enable_focus_reporting
  bindkey '\033[I' _terminal_focus_in
fi
