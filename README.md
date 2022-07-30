# pyHack

**pyHack** is a simple theme for **ZSH** that shows Python version, [Python](https://python.org) package version (*pyproject.toml*) and [Git](https://git-scm.com/) current branch information.

![image](https://raw.githubusercontent.com/williamcanin/pyhack/assets/screenshot/img0.jpg)

## Installing

1 - Clone your user's HOME:

```
git clone --single-branch https://github.com/williamcanin/pyhack.git ~/.pyhack
```

2 - Load **pyHack** in *~/.zshrc*:

```
echo "source $HOME/.pyhack/pyhack.zsh-theme" >> ~/.zshrc
```

### Using with **Oh My ZSH**

Install [Oh My ZSH](https://ohmyz.sh/) and follow the steps below.

1 - Clone your user's **HOME**:

```
git clone --single-branch https://github.com/williamcanin/pyhack.git ~/.pyhack
```

2 - Create a symbolic link to **Oh My ZSH** custom themes folder:

```
ln -s ~/.pyhack/pyhack.zsh-theme $ZSH_CUSTOM/themes/pyhack.zsh-theme
```

3 - Activate the **pyHack**:

```
omz theme set pyhack
```

## Updating

To update **pyHack** to latest version, do:

```
cd ~/.pyhack; git pull origin main
```