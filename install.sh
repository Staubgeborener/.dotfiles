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

sudo apt update
sudo apt install -y \
      apt-transport-https \
      build-essential \
      ca-certificates \
      cargo \
      cifs-utils \
      curl \
      git \
      imagemagick \
      libasound2-dev \
      libbz2-dev \
      libfontconfig \
      libreadline-dev \
      libssl-dev \
      libsqlite3-dev \
      locales \
      meson \
      ninja-build \
      npm \
      openvpn \
      pass \
      pkg-config \
      ranger \
      rustc \
      snapd \
      software-properties-common \
      stow \
      sudo \
      zlib1g-dev \
      zsh \
    && sudo apt clean

sudo snap install \
      gh \
      keepassxc \
      spt

sudo npm install --global trash-cli
sudo npm install --global pure-prompt

sudo pip3 install thefuck

#spotifyd
#maybe edit ~/.config/spotifyd/spotifyd.conf and check devices with aplay -L
mkdir ~/.cache/spotifyd-offline-cache
git clone https://github.com/Spotifyd/spotifyd.git
cd spotifyd
cargo build --release --features dbus_mpris
cd $dotfilespath

#ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

#zsh plugins
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zdharma/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting

#kitty terminal
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
ln -s ~/.local/kitty.app/bin/kitty ~/.local/bin/
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
sed -i "s|Icon=kitty|Icon=/home/$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty.desktop
sudo ln -s ~/.local/kitty.app/bin/kitty /usr/bin

#polybar
sudo apt install -y \
  cmake cmake-data libcairo2-dev libxcb1-dev libxcb-ewmh-dev \
  libxcb-icccm4-dev libxcb-image0-dev libxcb-randr0-dev \
  libxcb-util0-dev libxcb-xkb-dev pkg-config python3-xcbgen \
  xcb-proto libxcb-xrm-dev i3-wm libasound2-dev libmpdclient-dev \
  libiw-dev libcurl4-openssl-dev libpulse-dev \
  libxcb-composite0-dev xcb libxcb-ewmh2 libjsoncpp-dev python3-sphinx
sudo apt -t buster-backports install -y polybar

#i3-gaps
#sudo apt install -y dh-autoreconf libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev xcb libxcb1-dev libxcb-icccm4-dev libyajl-dev libev-dev libxcb-xkb-dev libxcb-cursor-dev libxkbcommon-dev libxcb-xinerama0-dev libxkbcommon-x11-dev libstartup-notification0-dev libxcb-randr0-dev libxcb-xrm0 libxcb-xrm-dev libxcb-shape0 libxcb-shape0-dev
#git clone https://github.com/Airblader/i3 ~/i3
#cd ~/i3
#mkdir -p build && cd build
#meson --prefix /usr/local
#meson ..
#ninja
##sudo ninja install

mkdir /tmp/build 
cd /tmp/build
git clone https://www.github.com/Airblader/i3 i3-gaps
cd i3-gaps
git checkout gaps && git pull
sudo apt install meson asciidoc
meson -Ddocs=true -Dmans=true ../build
meson compile -C ../build
sudo meson install -C ../build

cd $dotfilespath
 
#cleaning up
rm ~/.zshrc ~/.config/i3/config ~/.config/polybar/config

stow -t ~ */
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
# sudo fc-cache -frv
# kitty list-fonts
