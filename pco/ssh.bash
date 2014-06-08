ssh-add -D > /dev/null 2>&1
ssh-add $HOME/.ssh/pco_servers $HOME/.ssh/id_rsa > /dev/null 2>&1

# export PULSAR_CONF_REPO="$HOME/Code/pco-deploy/"
