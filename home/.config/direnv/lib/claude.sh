# Automatically set CLAUDE_CONFIG_DIR for projects under ~/Code
if [[ "$PWD" == "$HOME/Code"* && -z "$CLAUDE_CONFIG_DIR" ]]; then
  export CLAUDE_CONFIG_DIR="$HOME/.claude_config_dirs/pco-team"
fi
