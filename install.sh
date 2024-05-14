#!/bin/zsh
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

# Add keys
sudo install -m 0755 -d /etc/apt/keyrings
# Docker Key
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# Spotify Key
curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
# Wezterm Key
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list

sudo apt update

# Docker
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
export PATH=/home/$USER/.cargo/bin:$PATH

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

# Rofi
sudo apt install -y flex bison libgtk-3-dev
git clone https://github.com/davatorium/rofi
cd rofi
meson setup build
ninja -C build
sudo ninja -C build install
cd ..
sudo rm -r rofi

# Spotify / Spicetify (Marketplace)
sudo apt install -y spotify-client
# Need to Start Spotify at least once to create the /home/$USER/.config/spotify/prefs file
# We need explicit Chrome Browser for this purpose:
if ! command -v google-chrome-stable; then
    echo "Google Chrome not installed which is required for the spotify login. Installing Google Chome ..."
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i google-chrome-stable_current_amd64.deb
    rm google-chrome-stable_current_amd64.deb
fi
# Force waiting
read -p "Now log in to spotify and press any key to continue the installation"
sudo chmod a+wr /usr/share/spotify
sudo chmod a+wr /usr/share/spotify/Apps -R
curl -fsSL https://raw.githubusercontent.com/khanhas/spicetify-cli/master/install.sh | sh
sudo apt purge google-chrome-stable

# Install thefuck
sudo pip3 install thefuck

# Install trash-cli
sudo pip3 install trash-cli
echo 'export PATH="$PATH":~/.local/bin' >> ~/.zshrc

# Cleaning up
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
