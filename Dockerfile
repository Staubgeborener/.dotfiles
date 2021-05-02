FROM debian:buster-slim

RUN apt-get update && \
    apt-get install -y \
      build-essential \
      curl \
      git \
      libbz2-dev \
      libreadline-dev \
      libssl-dev \
      libsqlite3-dev \
      locales \
      stow \
      sudo \
      zsh \
    && apt-get clean

RUN locale-gen de_DE.utf8
RUN useradd -s /bin/zsh tester
ADD . /home/tester/.dotfiles
RUN chown -R tester:tester /home/tester && \
    echo 'tester ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/tester && \
    chmod 0440 /etc/sudoers.d/tester
USER tester

ENV HOME /home/tester

WORKDIR /home/tester/.dotfiles
RUN chmod +x install.sh
RUN ./install.sh
RUN git submodule update --init
RUN stow -t ~ */
