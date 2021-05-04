#!/bin/zsh

#add keys
#docker
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
#stable docker repository
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
#openvpn
#sudo wget https://swupdate.openvpn.net/repos/openvpn-repo-pkg-key.pub

sudo apt update
sudo apt install -y \
      apt-transport-https \
      build-essential \
      ca-certificates \
      cargo \
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
cargo build --release
cd ..

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

#gpg
echo "Set up gpg keys for git and spotifd? (yes/no)"
read input
if [ "$input" == "yes"]
then
	read -p "Path to private key: " gpg-private-key
	read -p "Path to public key: " gpg-public-key
	gpg --import $(gpg-private-key)
	gpg --import $(gpg-public-key)
	echo ""
	gpg --list-secret-keys --keyid-format LONG
	read -p "Private key long id for git: " gpg-public-key-long-id
	git config --global user.signingkey $(gpg-public-key-long-id)
	read -p "Name for git: " git-name
	git config --global user.name $(git-name)
	read -p "Email for git: " git-email
	git config --global user.email $(git-email)
	echo "Lets do a test gpg sign:"
	echo "xyz" | gpg --clearsign
	echo ""
	gpg --list-keys
	read -p "Public Key for spotifyd: " spotifydpublickey
	echo "Ultimate trust commands: trust, 5, y, quit"
	gpg --edit-key $spotifydpublickey
	pass init $spotifydpublickey
	pass insert spotify
fi

rm ~/.zshrc
stow -t ~ */
source ~/.zshrc
chsh -s $(which zsh)

echo "Warning: Automatic logout in 5 seconds to apply settings!"
sleep 5
sudo pkill -u ${USER}
