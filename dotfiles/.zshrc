# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
ZSHRC_LOCAL=~/.zshrc.local
if [ -f "$ZSHRC_LOCAL" ]; then
    source $ZSHRC_LOCAL
else
    export USER_HOME=~
fi

export ZSH="$USER_HOME/.oh-my-zsh"
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="intheloop"

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    pipenv
    pyenv
    kubectl
    docker
    docker-compose
    aws
)

source $ZSH/oh-my-zsh.sh

# WSL specific
LS_COLORS="ow=01;36;40" && export LS_COLORS

# Make cd use the ls colours
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
autoload -Uz compinit
compinit
export DOCKER_HOST=unix:///var/run/docker.sock

export PATH="$PATH:/home/$USER_NAME/.local/bin/"
export PATH="/home/$USER_NAME/.pyenv/bin:$PATH"
export PATH="$HOME/anaconda3/bin/:$PATH"
export PATH="$HOME/.pyenv/bin/:$PATH"
export PATH="$HOME/.poetry/bin:$PATH"

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

alias dc='docker-compose'
alias dps='docker ps -a'
alias dataproc='gcloud beta dataproc'
eval "$(direnv hook zsh)"
alias tf='terraform'
alias vi='nvim'
alias yacc="bison"
alias kafkacat='docker run -it --rm --name=kafkacat --network=host edenhill/kafkacat:1.5.0 kafkacat'
alias ll='ls -lah'
alias ctop='docker run --rm -it --name=ctop -v /var/run/docker.sock:/var/run/docker.sock:ro quay.io/vektorlab/ctop:latest'
alias rm='sudo rm'
alias work-local='sshcode $USER_NAME@localhost --skipsync "/home/$USER_NAME/workspaces/" --ssh-flags "-p 2222 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"'
alias work-remote='sshcode'
