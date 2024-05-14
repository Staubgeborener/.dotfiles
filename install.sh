#!/bin/zsh
dotfilespath=`pwd`

#add keys
#docker
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
#stable docker repository
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
#openvpn
#sudo wget https://swupdate.openvpn.net/repos/openvpn-repo-pkg-key.pub
#backports
echo "deb http://deb.debian.org/debian buster-backports main contrib non-free" | sudo tee -a /etc/apt/sources.list
#spotify
curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add -
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list

sudo apt update
sudo apt install -y \
      apt-transport-https \
      asciidoc \
      build-essential \
      ca-certificates \
      cifs-utils \
      curl \
      fastfetch \
      feh \
      git \
      i3 \
      imagemagick \
      keepassxc \
      libasound2-dev \
      libbz2-dev \
      libfontconfig \
      libreadline-dev \
      libssl-dev \
      libsqlite3-dev \
      locales \
      meson \
      npm \
      openvpn \
      pass \
      pkg-config \
      ranger \
      software-properties-common \
      stow \
      sudo \
      wezterm \
      zlib1g-dev \
      zsh \
    && sudo apt clean

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
export PATH=/home/$USER/.cargo/bin:$PATH

cargo install spotify-tui

sudo npm install --global trash-cli
sudo npm install --global pure-prompt

sudo pip3 install thefuck

# ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# zsh plugins
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Polybar
mkdir $HOME/.config/polybar
cp /etc/polybar/config.ini $HOME/.config/polybar/config.ini

echo -e '#!/usr/bin/env bash
polybar-msg cmd quit
echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
polybar bar1 2>&1 | tee -a /tmp/polybar1.log & disown' > $HOME/.config/polybar/launch.sh

chmod +x $HOME/.config/polybar/launch.sh

# Add polybar to i3
sed -i '/^bar {/,/^}/d' ~/.config/i3/config
echo 'exec_always --no-startup-id $HOME/.config/polybar/launch.sh' >> ~/.config/i3/config

mkdir /tmp/build

#rofi
cd /tmp/build
sudo apt install -y flex bison libgtk-3-dev
git clone https://github.com/davatorium/rofi
cd rofi
meson setup build
ninja -C build
sudo ninja -C build install
cd $dotfilespath

#spotify / spicetify
sudo apt install -y spotify-client
cd ~/.config
curl -fsSL https://raw.githubusercontent.com/khanhas/spicetify-cli/master/install.sh | sh
sudo chmod a+wr /usr/share/spotify
sudo chmod a+wr /usr/share/spotify/Apps -R
~/.config/spicetify/spicetify config current_theme Arc-Dark
~/.config/spicetify/spicetify apply
cd $dotfilespath

#cleaning up
rm ~/.zshrc ~/.config/i3/config ~/.config/polybar/config ~/.config/spicetify/config-xpui.ini

stow -t ~ */
zsh
source ~/.zshrc
chsh -s $(which zsh)

echo "Warning: Automatic logout in 5 seconds to apply settings!"
sleep 5
sudo pkill -u ${USER}

### MANUAL GPG KEY SETUP ###
#--------------------------#
# gpg --import $(gpg-private-key)
# gpg --import $(gpg-public-key)
# gpg --list-secret-keys --keyid-format LONG
# git config --global user.signingkey GPG-KEYID-LONGFORMAT
# git config --global user.name USERNAME
# git config --global user.email EMAIL
# echo "signing test" | gpg --clearsign
# gpg --list-keys
# echo "Ultimate trust commands: trust, 5, y, quit"
# gpg --edit-key PUBLICKEY
# pass init PUBLICKEY
# pass insert spotify

### MANUAL FONTS SETUP ###
#------------------------#
# Copy all fonts into /usr/share/fonts/
# set permissions!
# fc-cache -frv
# sudo fc-cache -frv

### VERACRYPT ###
#_______________#
# wget https://launchpad.net/veracrypt/trunk/1.24-update7/+download/veracrypt-1.24-Update7-setup.tar.bz2
# tar -xf veracrypt-1.24-Update7-setup.tar.bz2
# ./veracrypt-1.24-setup-gui-x64
