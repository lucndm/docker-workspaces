FROM ubuntu:18.04
ENV USER lucndm 
ENV PYTHON_VERSION_DEFAULT 3.8.0
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
    tk-dev libncurses5-dev libncursesw5-dev zsh build-essential \
    direnv docker-ce google-cloud-sdk

RUN sudo apt autoremove -y python python3

RUN adduser --gecos '' --disabled-password $USER && \
	echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd
RUN git clone https://github.com/tmux/tmux.git /tmp/tmux \
    && cd /tmp/tmux && bash ./autogen.sh && ./configure && make && sudo make install \
    && sudo cp tmux /usr/bin && sudo rm -rf /tmp/tmux
USER $USER
RUN sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" \
    && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
RUN sudo apt-get remove -y libssl-dev
RUN sudo apt-get install -y --no-install-recommends  \
    libbz2-dev libreadline-dev python-openssl libssl1.0-dev libsqlite3-dev iproute2 libedit-dev libffi-dev openssh-server rsync
ENV USER_HOME=/home/$USER
RUN curl https://pyenv.run | bash \
    && $USER_HOME/.pyenv/bin/pyenv install ${PYTHON_VERSION_DEFAULT} \
    && $USER_HOME/.pyenv/bin/pyenv global ${PYTHON_VERSION_DEFAULT}
# COPY ./resources/.zsh_history ${USER_HOME}
RUN cd ~ && git clone https://github.com/minhlucnd/.tmux.git \
    && ln -s -f .tmux/.tmux.conf
ADD ./dotfiles/.zshrc ${USER_HOME}
ADD ./dotfiles/.tmux.conf.local ${USER_HOME} 
RUN sudo chown ${USER}:${USER} $USER_HOME/.tmux.conf.local ${USER_HOME}/.zshrc
RUN mkdir -p $USER_HOME/workspaces
RUN mkdir -p $USER_HOME/.local/share/code-server
WORKDIR $USER_HOME/workspaces
VOLUME ["/home/$USER/workspaces"]
# RUN mkdir -p /var/log/supervisor 
# COPY ./resources/supervisord.conf /etc/supervisor/conf.d/
RUN mkdir -p ${USER_HOME}/.ssh/
RUN sudo rm -rf /var/lib/apt/lists/*
RUN sudo usermod -aG docker $USER
RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python
COPY ./requirements-dev.txt /tmp/requirements-dev.txt
RUN ${USER_HOME}/.pyenv/shims/pip install -r /tmp/requirements-dev.txt && sudo rm -rf /tmp/requirements-dev.txt
COPY fabfile.py fabfile.py
COPY ./tests tests
# RUN python fabfile.py
RUN ${USER_HOME}/.pyenv/versions/${PYTHON_VERSION_DEFAULT}/bin/fab bootstrap && sudo rm -rf tests 