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

RUN sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tk-dev

RUN sudo apt-get install -y zsh build-essential \
    direnv docker-ce google-cloud-sdk

RUN sudo apt autoremove -y python python3
RUN adduser --gecos '' --disabled-password coder && \
	echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd

RUN sudo rm -rf /var/lib/apt/lists/*
USER coder