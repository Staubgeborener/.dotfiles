#!/bin/zsh

#add keys
#docker
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
#stable docker repository
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
#openvpn
sudo wget https://swupdate.openvpn.net/repos/openvpn-repo-pkg-key.pub

sudo apt update
sudo apt install -y \
      apt-transport-https \
      build-essential \
      ca-certificates \
      cargo \
      curl \
      git \
      libasound2-dev \
      libbz2-dev \
      libfontconfig \
      libreadline-dev \
      libssl-dev \
      libsqlite3-dev \
      locales \
      npm \
      openvpn \
      pkg-config \
      rustc \
      snapd \
      software-properties-common \
      stow \
      sudo \
      zlib1g-dev \
      zsh \
    && apt-get clean

sudo snap install \
      gh \
      keepassxc \
      spt

sudo npm install --global trash-cli

sudo pip3 install thefuck

#spotifyd
git clone https://github.com/Spotifyd/spotifyd.git
cd spotifyd
cargo build --release
cd ..

#ohmyzsh
#sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

#beautify zsh and add plugins
cd ~/.oh-my-zsh/custom && \
git clone https://github.com/sindresorhus/pure && \
ln -s pure/pure.zsh-theme . && \
ln -s pure/async.zsh .
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

#zsh shell
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
# Create a symbolic link to add kitty to PATH (assuming ~/.local/bin is in
# your PATH)
ln -s ~/.local/kitty.app/bin/kitty ~/.local/bin/
sudo ln -s ~/.local/kitty.app/bin/kitty /usr/bin
# Place the kitty.desktop file somewhere it can be found by the OS
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
# Update the path to the kitty icon in the kitty.desktop file
sed -i "s|Icon=kitty|Icon=/home/$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty.desktop
#mate-default-applications-properties

stow -t ~ */
source ~/.zshrc
chsh -s $(which zsh)
#logout
