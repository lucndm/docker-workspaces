# echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/dont-prompt-$USER-for-password
sudo apt-get remove docker docker-engine docker.io containerd runc
# sudo tee /etc/apt/sources.list.d/pritunl.list << EOF
# deb http://repo.pritunl.com/stable/apt bionic main
# EOF
sudo apt-get update

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y apt-transport-https ca-certificates gnupg gnupg2 curl software-properties-common cmake automake libevent-dev bison
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
 
sudo apt-get update
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
 
sudo apt-get install -y zsh build-essential zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
xz-utils tk-dev libffi-dev liblzma-dev python-openssl git libedit-dev libssl1.0-dev \
neovim direnv google-cloud-sdk docker-ce
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
sudo chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
 
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
# sh -c "$(wget https://pyenv.run -O -)"
curl https://pyenv.run | bash
python "$(wget https://raw.githubusercontent.com/kennethreitz/pipenv/master/get-pipenv.py -O -)"
pyenv install 3.7.5
pyenv global 3.7.5
pip install --upgrade pip
pip install pipenv ansible youtube-dl --user
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# cp -r ./.ssh ~
# chmod 700 ~/.ssh/
# chmod 600 ~/.ssh/id_rsa
# chmod 600 ~/.ssh/id_rsa.pub
# cp -r ./.aws ~
# cp ~/.zshrc ~/.zshrc.bak
# cp -r ./.zshrc ~/
# # sh -c "compaudit | xargs chmod g-w,o-w"
# source ~/.zshrc
 
# sudo usermod -aG docker $USER