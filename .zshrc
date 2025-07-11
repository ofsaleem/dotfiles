# Start fastfetch with each new instant of zsh. Has to go here, above p10k
# instant prompt initialization.
fastfetch -c archey.jsonc

# Enable Powerlevel10k instant prompt. Should stay close to the top of
# ~/.zshrc.  Initialization code that may require console input (password
# prompts, [y/n] confirmations, etc.) must go above this block; everything else
# may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/go/bin:$HOME/bin:/usr/local/bin:$HOME/.local/bin:$(yarn global bin):$PATH

# add prebuilt completion scripts
[[ -f ~/.zsh-completions ]] && source ~/.zsh-completions

# Path to your oh-my-zsh installation.
system_type=$(uname -s)
if [ "$system_type" = "Darwin" ]; then
  export ZSH="/Users/omar/.oh-my-zsh"
elif [ "$system_type" = "Linux" ]; then
  export ZSH="$HOME/.oh-my-zsh"
else
  export ZSH="$HOME/.oh-my-zsh"
fi

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git aws dash docker gcloud golang history jsontools kubectl nvm pip sudo terraform zsh-syntax-highlighting history-substring-search direnv poetry)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

export EDITOR="nvim"
export VISUAL=$EDITOR
export PAGER="nvimpager"
export VIMPAGER_VIM="nvim"
#export MANPAGER='nvim +Man!'
export MANPAGER="nvimpager"
export XDG_CONFIG_HOME=~/.config
export XDG_DATA_HOME=~/.local/share
export GOPATH=~/go/
export BAT_THEME="Solarized (dark)"
export CLOUDSDK_PYTHON=python3.9
export USE_GKE_CLOUD_AUTH_PLUGIN=True
# TODO find a better way to handle this because this will break everywhere else
[[ -f ~/workspace/awsenv ]] && source ~/workspace/awsenv
alias vim="nvim"
alias less="nvimpager"
alias vimpager="nvimpager"
alias vimcat='nvimpager -c'
alias vimrc='vim ~/.config/nvim/init.vim'
alias nvimrc='vimrc'
alias zshrc='vim ~/.zshrc'


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# add gcloud path and completion
[[ -f ~/.gcloud-zsh-config ]] && source ~/.gcloud-zsh-config

# add thefuck
# eval $(thefuck --alias) 

# add flux completion
command -v flux >/dev/null && . <(flux completion zsh) && compdef _flux flux


# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/omar/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions
