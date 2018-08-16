#!/bin/bash

TEMP_DIR=$HOME/config_tmp

# Unzip the files
if [ -f $1 ]; then
    ARCH_FILE=$(realpath $1)
    mkdir -p $TEMP_DIR && cd $TEMP_DIR
    case "$ARCH_FILE" in
        *.tar.bz2)   tar xjf "$ARCH_FILE"     ;;
        *.tar.gz)    tar xzf "$ARCH_FILE"     ;;
        *.bz2)       bunzip2 "$ARCH_FILE"     ;;
        *.rar)       unrar e "$ARCH_FILE"     ;;
        *.gz)        gunzip "$ARCH_FILE"      ;;
        *.tar)       tar xf "$ARCH_FILE"      ;;
        *.tbz2)      tar xjf "$ARCH_FILE"     ;;
        *.tgz)       tar xzf "$ARCH_FILE"     ;;
        *.zip)       unzip "$ARCH_FILE"       ;;
        *)           echo "'$ARCH_FILE' cannot be extracted by $SCRIPTNAME" ;;
    esac
    cd $HOME
fi

CONFIG_DIR=$HOME/.dot_config
[ -d "$CONFIG_DIR" ] || cp -a $TEMP_DIR/.dot_config $HOME/

# Get this distro
DISTRO=$( cat /etc/*-release | tr [:upper:] [:lower:] | grep -Poi '(debian|ubuntu|red hat|centos)' | uniq )
if [ -z $DISTRO ]; then
    DISTRO='unknown'
fi
echo "Detected Linux distribution: $DISTRO"

# Install fzf
[ -f $HOME/bin/fzf ] ||
if [ -f $TEMP_DIR/fzf] ; then
    cp $TEMP_DIR/fzf $HOME/bin/
    chmod +x $HOME/bin/fzf
    cp -a $TEMP_DIR/.fzf $HOME/
    source $HOME/.fzf/install
else
    echo 'No fzf file'
fi

# Install tmux
command -v tmux > /dev/null 2>&1 ||
if [ "$DISTRO" == "ubuntu" ] ; then
    sudo apt-get install tmux
fi

# Install tmuxp
command -v tmuxp > /dev/null 2>&1 ||
pip install --user tmuxp
cp -a $TEMP_DIR/.tmuxp $HOME/

# Install xsel, used by tmux-yank
if [ "$DISTRO" == "ubuntu" ] ; then
    sudo apt-get install xsel
fi

# Tmux plugins and configs
mkdir -p $HOME/.tmux
cp -a $TEMP_DIR/.tmux/* $HOME/.tmux/*
mkdir -p $HOME/tools/tmux_plugins
cp -a $TEMP_DIR/tmux_plugins/* $HOME/tools/tmux_plugins/
cp $TEMP_DIR/.tmux.conf $HOME/

# Install screenrc
cp $TEMP_DIR/.screenrc $HOME/

# Install .customrc
echo '[ -f '$CONFIG_DIR'/.customrc ] && source '$CONFIG_DIR'/.customrc' >> $HOME/.bashrc
echo '[ -f '$CONFIG_DIR'/.customrc ] && source '$CONFIG_DIR'/.customrc' >> $HOME/.bash_profile

# Install vim config
mkdir -p $HOME/.vim
cp -a $TEMP_DIR/.vim/* $HOME/.vim/

# Install local
mkdir -p $HOME/.local
cp -a $TEMP_DIR/.local/* $HOME/.local/

# Install adb tools
sudo apt-get install android-tools-adb android-tools-fastboot
sudo usermod -a -G plugdev $USER

# Install synergy
command -v synergyc > /dev/null 2>&1 ||
if [ -f $TEMP_DIR/synergy-*.deb ] ; then
    PACKAGE_NAME=$(ls -d -1 $TEMP_DIR/synergy*)
    sudo apt install $PACKAGE_NAME
fi

# Gitignore
[ -f $CONFIG_DIR/.gitignore ] && git config --global core.excludesfile $CONFIG/.gitignore

# At the end, delete the temp directory
rm -rf $TEMP_DIR > /dev/null
