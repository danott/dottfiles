# dottfiles

@danott's dotfiles. 

## Structure

Configuration files live in `home/`. The directory structure mirrors `$HOME`, so `home/.vimrc` gets symlinked to `~/.vimrc`, `home/.config/starship.toml` to `~/.config/starship.toml`, etc.

The `install` script automatically symlinks everything from `home/` to my home directory. It also runs `brew bundle` to install packages from the `Brewfile`. I may remove this later.

## Installation

```bash
git clone git@github.com:danott/dottfiles.git $HOME/dottfiles
cd $HOME/dottfiles
./install
```

The install script will tell me if any files already exist that need to be backed up or moved before linking.

## Adding new configs

Just add them to `home/` following the same path structure as my home directory. Run `./install` to link them.
