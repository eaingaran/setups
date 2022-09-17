#!/bin/bash

set -e

# install prerequisites
PREREQUISITES="ed git wget thefuck fzf zsh"
APPS_TO_INSTALL=""
APPS_NOT_INSTALLED=""

# find out what needs to be installed
for APP in $PREREQUISITES
do
    if ! command -v $APP &> /dev/null; then
        APPS_TO_INSTALL="$APPS_TO_INSTALL $APP"
    fi
done

# install the missing prerequisites
if [[ APPS_TO_INSTALL == "" ]]; then
    echo -e "Prerequisites already exist"
elif sudo apt update && sudo apt install -y $APPS_TO_INSTALL; then
        echo -e "Prerequisites are installed\n"
else
    echo "Unable to install prerequisites"
fi

for APP in $APPS_TO_INSTALL
do
    if ! command -v $APP &> /dev/null; then
        APPS_NOT_INSTALLED="$APPS_NOT_INSTALLED $APP"
    fi
done

if ! [[ $APPS_NOT_INSTALLED == "" ]]; then
    echo -e "Please install the following packages manually and try again:$APPS_NOT_INSTALLED \n"
    exit 1
fi


if mv -n ~/.zshrc ~/.zshrc-bck-$(date +"%Y-%m-%d"); then # backup .zshrc (important if zsh was already setup)
    echo -e "Backed up the current .zshrc to .zshrc-bck-$(date +\"%Y-%m-%d\")\n"
fi

# installing source code pro nerd font
mkdir -p ~/.local/share/fonts
(cd ~/.local/share/fonts && wget --tries=3 -O "Sauce Code Pro Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete.ttf)

# switch to zsh
touch ~/.zshrc && source ~/.zshrc

# install oh-my-zsh
HOME=~
if ! [ -d "$HOME/.oh-my-zsh/" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
fi

# install zsh custom plugins, if not already installed
if ! [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions/" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
fi

if ! [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
fi

# install starship
wget --tries=3 -O "install.sh" https://starship.rs/install.sh
sh install.sh -y
rm install.sh

# setup starship
mkdir -p ~/.config && (cd ~/.config/ && wget --tries=3 -O "starship.toml" https://github.com/eaingaran/configs/raw/main/starship.toml)

# setup zsh config
(cd ~ && wget --tries=3 -O ".zshrc" https://github.com/eaingaran/configs/raw/main/.zshrc)

# switch to the new shell
source ~/.zshrc
