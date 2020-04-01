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
ZSH_THEME="pygmalion"
 
plugins=(
    git
    colorize
    pip
    brew
    colored-man-pages
    gcloud
    python
    zsh-autosuggestions
    zsh-syntax-highlighting
    pipenv
    pyenv
    kubectl
    docker
    docker-compose
    aws
    dotenv
    helm
)
 
source $ZSH/oh-my-zsh.sh
 
 
 
# Make cd use the ls colours
#zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
#autoload -Uz compinit
#compinit
 
export PATH=$PATH:~/.local/bin
export DOCKERHOST=unix:///var/run/docker.sock
export PATH="~/.pyenv/bin:$PATH"
export POETRY_VIRTUALENVS_PATH=./.venv
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
 
alias dc='docker-compose'
alias dps='docker ps -a'
alias dataproc='gcloud beta dataproc'
eval "$(direnv hook zsh)"
alias tf='terraform'
alias vi='nvim'
#alias yacc="bison"
alias kafkacat='docker run -it --rm --name=kafkacat --network=host edenhill/kafkacat:1.5.0 kafkacat'
alias ll='ls -lah'
alias ctop='docker run --rm -it --name=ctop -v /var/run/docker.sock:/var/run/docker.sock:ro quay.io/vektorlab/ctop:latest'
export PATH="$HOME/.pyenv/bin/:$PATH"
export PATH="$HOME/.poetry/bin:$PATH"
export POETRY_VIRTUALENVS_IN_PROJECT="true"
alias rm='sudo rm'
export tf='terraform'
function ssh-gcp(){
    gcloud compute ssh $1 --zone=$(gcloud compute instances list | grep $1 | awk '{print $2}')
}
export PATH="${PATH}:${HOME}/.krew/bin"
alias kubens="kubectl ns"
alias kubectx="kubectl ctx"
export GOOGLE_APPLICATION_CREDENTIALS="/tmp/key.json"
function get_credentials() {
    ACTIVE_CONFIG=$(cat ${HOME}/.config/gcloud/active_config)
    ACTIVE_ACCOUNT=$(cat ${HOME}/.config/gcloud/configurations/config_${ACTIVE_CONFIG} | grep account | awk '{print $3}')
    sqlite3 ${HOME}/.config/gcloud/credentials.db "SELECT value FROM credentials WHERE account_id = '${ACTIVE_ACCOUNT}'" > $GOOGLE_APPLICATION_CREDENTIALS
}
export PIPENV_VENV_IN_PROJECT=true
