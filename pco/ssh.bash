ssh-add -D > /dev/null 2>&1
ssh-add $HOME/.ssh/pco_servers $HOME/.ssh/id_rsa > /dev/null 2>&1

# Note: See ~/.pulsar

alias b="pco box"
alias be="pco box exec"
alias bbe="pco box bundle exec"
alias bbi="pco box bundle install"
alias bguard="pco box guard"
alias bar="pco box apprestart"
