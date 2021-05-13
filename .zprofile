# Add dottfiles scripts to the path
PATH="$PATH:$HOME/Code/dottfiles/bin"
EDITOR=vim


# Homebrew across platforms
test -d /opt/homebrew && eval "$(/opt/homebrew/bin/brew shellenv)"
test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)

# Ruby
eval "$(rbenv init -)"

# Setup SSH Agent for connecting to remote machines
ssh-add -D > /dev/null 2>&1
ssh-add -A $HOME/.ssh/id_rsa > /dev/null 2>&1

# Configuration that is unique to the local machine
if [ -f "$HOME/.zprofile.local" ]; then
  source "$HOME/.zprofile.local"
fi
