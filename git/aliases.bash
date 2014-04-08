#!/bin/bash

alias gco="git checkout"
alias gca="git commit -a"
alias gd="git difftool"
alias gl="git pull"
alias gp="git push"
alias gs="git status"

# Completions for aliases
__git_complete gco _git_checkout
