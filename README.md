# .dotfiles

### Clone

```shell
git clone --recursive https://github.com/Staubgeborener/.dotfiles.git $HOME/.dotfiles
cd $HOME/.dotfiles
stow -t ~ */ # or use the script to install all dependencies and packages
```

### Updating

```shell
git pull --recurse-submodules
```

### Testing

```shell
sudo docker build -t dotfilestester -f Dockerfile . && docker run -it dotfilestester
```
