FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y \
      build-essential \
      curl \
      git \
      libbz2-dev \
      libfontconfig \
      libreadline-dev \
      libssl-dev \
      libsqlite3-dev \
      locales \
      stow \
      sudo \
      zlib1g-dev \
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

RUN git clone --depth=1 https://github.com/pyenv/pyenv.git ${HOME}/.pyenv
ENV PATH="${HOME}/.pyenv/shims:${HOME}/.pyenv/bin:${PATH}"

ENV PYTHON_VERSION=3.9.0
RUN pyenv install ${PYTHON_VERSION}
RUN pyenv global ${PYTHON_VERSION}

RUN chmod +x install.sh
RUN git submodule update --init
RUN stow -t ~ */