# nvim install: https://github.com/neovim/neovim/blob/master/INSTALL.md#linux
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz

export PATH="$PATH:/opt/nvim-linux64/bin"

sudo rm -r ~/.config/nvim/

# NcChad install: https://nvchad.com/docs/quickstart/install/
echo "Run :MasonInstallAll in nvim"
sleep 2
git clone https://github.com/NvChad/starter ~/.config/nvim && nvim
sudo rm -r ~/.config/nvim/.git
