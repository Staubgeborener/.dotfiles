# .dotfiles

### Clone

```shell
git clone --recursive https://github.com/Staubgeborener/.dotfiles.git $HOME/.dotfiles
cd $HOME/.dotfiles
stow -t ~ */
```

### Updating

```shell
git pull --recurse-submodules
```

### Testing

```shell
sudo docker build -t DotfilesTester -f Dockerfile . && docker run -it DotfilesTester
```
