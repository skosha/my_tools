#!/usr/bin/env bash

set -e # Terminate script if anything exits with a non-zero value

if [ ! -d "$HOME/bin/" ]; then
    mkdir -p $HOME/bin
fi

if [ ! -f "$HOME/.zshrc" ]; then
    touch $HOME/.zshrc
fi

echo 'export PATH="$HOME/bin:$PATH"' >> $HOME/.zshrc

HOMEBREW_PREFIX="/usr/local"

if [ -d "$HOMEBREW_PREFIX" ]; then
  if ! [ -r "$HOMEBREW_PREFIX" ]; then
    sudo chown -R "$LOGNAME:admin" /usr/local
  fi
else
  sudo mkdir "$HOMEBREW_PREFIX"
  sudo chflags norestricted "$HOMEBREW_PREFIX"
  sudo chown -R "$LOGNAME:admin" "$HOMEBREW_PREFIX"
fi

if ! grep "$shell_path" /etc/shells > /dev/null 2>&1 ; then
    sudo sh -c "echo $shell_path >> /etc/shells"
fi
sudo chsh -s "$shell_path" "$USER"

echo 'export PATH="/usr/local/bin:$PATH"' >> $HOME/.zshrc
export PATH="/usr/local/bin:$PATH"

if ! command -v brew >/dev/null; then
    echo "Installing Homebrew ..."
    curl -fsS \
      'https://raw.githubusercontent.com/Homebrew/install/master/install' | ruby

    echo '' >> $HOME/.zshrc
    echo 'export PATH="/usr/local/bin:$PATH"' >> $HOME/.zshrc

    export PATH="/usr/local/bin:$PATH"
fi

brew_install() {
    local formulae="$1"; shift

    if brew list | grep -Fq $formulae; then
        brew install $formulae
    fi
}

echo "Updating Homebrew formulae ..."
brew update --force # https://github.com/Homebrew/brew/issues/1151
brew tap caskroom/cask
brew tap caskroom/versions
brew tap homebrew/bundle
brew tap homebrew/core
brew tap homebrew/services
brew tap thoughtbot/formulae
brew tap universal-ctags/universal-ctags

# Need to install openssl before libyaml
brew_install("openssl")
brew_install("openssl@1.1") # wget dependency

brew_install("autoconf") # asdf dependency
brew_install("automake") # asdf dependency
brew_install("awscli")
brew_install("cloc")
brew_install("cmake")
brew_install("coreutils")

brew_install("diff-so-fancy")
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
git config --global color.ui true
git config --global color.diff-highlight.oldNormal    "red bold"
git config --global color.diff-highlight.oldHighlight "red bold 52"
git config --global color.diff-highlight.newNormal    "green bold"
git config --global color.diff-highlight.newHighlight "green bold 22"
git config --global color.diff.meta       "yellow"
git config --global color.diff.frag       "magenta bold"
git config --global color.diff.commit     "yellow bold"
git config --global color.diff.old        "red bold"
git config --global color.diff.new        "green bold"
git config --global color.diff.whitespace "red reverse"

brew_install("dos2unix")
brew_install("git")
brew_install("gpg") # asdf-nodejs dependency
brew_install("htop")
brew_install("mas")
mas 'Fantastical 2', id: 975937182

brew_install("pgcli")
brew_install("python")
brew_install("python3")
brew_install("readline")
brew_install("reattach-to-user-namespace")
brew_install("the_silver_searcher")
brew_install("tmux")
brew_install("tree")
brew install --HEAD universal-ctags/universal-ctags/universal-ctags
brew_install("wget")
brew_install("zsh")

# Install iTerm2
brew cask install iterm2

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# zsh plugins
brew install zsh-completions
brew install zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# zsh themes
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

# Powerline fonts
git clone https://github.com/powerline/fonts.git ~/tools/fonts
sh ~/tools/fonts/install.sh

# .zshrc
wget https://raw.githubusercontent.com/skosha/my_tools/master/.dot-config/.zshrc

# Install task-warrior
brew install task
brew install taskd
brew install tasksh

# Install Vundle for Vim
mkdir -p ~/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# tmux plugins
mkdir -p ~/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# iterm colors
cd Downloads
curl -O https://raw.githubusercontent.com/MartinSeeler/iterm2-material-design/master/material-design-colors.itermcolors

# tmux copy/paste
brew install reattach-to-user-namespace
