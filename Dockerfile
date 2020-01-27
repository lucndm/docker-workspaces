FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
    curl wget openssl git sudo locales net-tools gnupg gnupg2 apt-transport-https ca-certificates software-properties-common

RUN locale-gen en_US.UTF-8
ENV LC_ALL=en_US.UTF-8 \
	SHELL=/bin/bash

RUN apt-get install -y \
    cmake automake libevent-dev bison

RUN sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A

RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | \
    sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - \
    && sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    && sudo apt-get update

RUN sudo curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
    && sudo chmod +x /usr/local/bin/docker-compose

RUN sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    tk-dev libncurses5-dev libncursesw5-dev

RUN sudo apt-get install -y zsh build-essential \
    direnv docker-ce google-cloud-sdk

RUN sudo apt autoremove -y python python3
RUN adduser --gecos '' --disabled-password coder && \
	echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd
RUN git clone https://github.com/tmux/tmux.git /tmp/tmux \
    && cd /tmp/tmux && bash ./autogen.sh && ./configure && make && sudo make install \
    && sudo cp tmux /usr/bin && sudo rm -rf /tmp/tmux
USER coder
RUN sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" \
    && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
COPY ./resources/.zshrc /home/coder/
RUN mkdir -p /home/coder/workspaces
RUN mkdir -p /home/coder/.local/share/code-server
WORKDIR /home/coder/workspaces
VOLUME ["/home/coder/workspaces"]
RUN sudo rm -rf /var/lib/apt/lists/*