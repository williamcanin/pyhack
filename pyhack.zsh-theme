#!/usr/bin/env zsh
#
# Theme name: pyhack
# Description: A ZSH Terminal for Python Hackers
# Author: William C. Canin <https://williamcanin.github.io>
# Readme: https://github.com/williamcanin/pyhack
# Version: 0.1.1
# License: https://github.com/williamcanin/pyhack/blob/main/LICENSE
# Dependencies: zsh>=5.9


### Basic settings
    ## Enable to show Python version. Option: y|n
    ENABLE_PYVERSION="y"

    ## Enable to show Python packages version using "pyproject.toml". Option: y|n
    ENABLE_PKGVERSION="y"

    ## Option to enable/disable Virtualenv. Option: y|n
    ENABLE_VENV="y"

    ## Disable virtualenv
    export VIRTUAL_ENV_DISABLE_PROMPT=1

    ## Enable substitution in the prompt.
    setopt prompt_subst


### Plugins
    ## Auto Suggestions
    zsh_autosuggestions=$(find /usr/share/zsh* -name "zsh-autosuggestions.zsh")
	if [[ -f $zsh_autosuggestions && ! -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]]; then; source $zsh_autosuggestions; fi
    ## Syntax Highlighting
    zsh_syntax_highlighting=$(find /usr/share/zsh* -name "zsh-syntax-highlighting.zsh")
	if [[ -f $zsh_syntax_highlighting && ! -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]]; then; source $zsh_syntax_highlighting; fi


### Functions
    ## Get distro ID (Unused)
    # function get_distro {
    #     awk -F= '$1=="ID" { print $2 ;}' /etc/os-release
    # }

    ## Coloring elements
    function colorize {
        # Use: colorize "<color>" "<object>" "<separator_begin>" "<separator_end>"
        # colors: green,red,white,cyan,yellow
        echo -e "${3}%F{${1}}${2}%F{none}${4}"
    }

    ## Separator for elements
    function separator {
        colorize "white" ":::"
    }

    ## Search extensions in which Python uses
    # pattern: ".*\.\(py\|pyc\|.whl\)"
    function search_ext {
        echo $(find -maxdepth 1 -regex ".*\.\(py\|pyc\|whl\)" 2>/dev/null)
    }

    ## Get Virtualenv
    function venv {
        [[ $VIRTUAL_ENV && $ENABLE_VENV == "y" ]] && colorize "green" "`basename $VIRTUAL_ENV`" $(separator)
    }

    ## Verify user, common or root
    function user {
        ## User name: '{%n}::'
        if [[ $UID -eq 0 ]]; then colorize "red" "%B#%b "; else colorize "green" "%B$%b "; fi
    }

    ## Show host
    ## Note: Host will only be shown via SSH
    function host {
        hostname=$(colorize "green" "[%m]" "" ":")
        if [[ $SSH_CONNECTION ]]; then echo "$hostname"; else echo ''; fi
    }

    ## Get directory
    function directory {
        colorize "green" "[%2~]"
    }

    ## Get package version
    function pkgversion {
        if [[ $ENABLE_PKGVERSION == "y" && -f pyproject.toml ]]; then
            version=$(grep '^version' pyproject.toml | cut -d'=' -f2 | cut -d'"' -f2)
            [[ -n $version ]] || return
            colorize "green" "pkg:$version" $(separator)
        fi
    }

    ## Get Python version
    function pyversion {

        ## Check if you have Python on the system
        if [[ $(which python3) >/dev/null ]] && [[ $ENABLE_PYVERSION == "y" ]]; then

            ## Checks various file types used by Python
            [[ -f .python-version || -f requirements.txt || -f pyproject.toml || -n $(search_ext) ]] || return

            ## Get the system Python version
            pysys=$(python -c 'import sys; sys.stdout.write(".".join(map(str, sys.version_info[:3])))')

            ## Checks the local and global version of Pyenv, and the system
            if [[ -f .python-version ]]; then
                version="$(head -n 1 .python-version)"
                if [[ $version == "system" ]]; then version="$pysys"; else version="$version"; fi
            elif [[ -f $HOME/.pyenv/version ]]; then
                version="$(head -n 1 $HOME/.pyenv/version)"
                if [[ $version == "system" ]]; then version="$pysys"; else version="$version"; fi
            else
                version="$pysys"
            fi

            ## Return version
            colorize "green" "py:$version" $(separator)

        fi

    }

    ## Prompt style and behavior
    function prompt {
        if [[ -f .python-version ||
        -f requirements.txt ||
        -f pyproject.toml ||
        -n ${vcs_info_msg_0_} ||
        -n $(search_ext) ]]; then
            jumpline="\n"
        else
            jumpline=""
        fi
        ## Option cmdline arrow: » | > | ->
        retval="${jumpline}\
        $(host)\
        $(directory)\
        $(venv)\
        $(pyversion)\
        $(pkgversion)\
        ${vcs_info_msg_0_}\
        ${jumpline}"

        echo "${retval// /}$(user)"
    }


### Git settings
    ## Autoload zsh add-zsh-hook and vcs_info functions (-U autoload w/o substition, -z use zsh style)
    autoload -Uz add-zsh-hook vcs_info

    ## Enable substitution in the prompt.
    setopt prompt_subst

    ## Run vcs_info just before a prompt is displayed (precmd)
    add-zsh-hook precmd vcs_info

    ## Enable checking for (un)staged changes, enabling use of %u and %c
    zstyle ':vcs_info:*' check-for-changes true

    ## Set custom strings for an unstaged vcs repo changes (*) and staged changes (+)
    zstyle ':vcs_info:*' unstagedstr ' *'
    zstyle ':vcs_info:*' stagedstr ' +'

    ## Set the format of the Git information for vcs_info
    # zstyle ':vcs_info:git:*' formats       '%F{white}:::%F{green}git:%b%u%c'
    # zstyle ':vcs_info:git:*' actionformats '%F{white}:::%F{green}git:%b|%a%u%c'
    zstyle ':vcs_info:git:*' formats        $(colorize "green" "git:%b(%u%c)" $(separator))
    zstyle ':vcs_info:git:*' actionformats  $(colorize "green" "git:%b|(%a%u%c)" $(separator))


### Set prompt
    PROMPT='$(prompt)'
