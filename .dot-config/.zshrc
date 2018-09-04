#If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export PATH=$HOME/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
export EDITOR="vim"
export BUNDLER_EDITOR=$EDITOR
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
export SOURCE_ANNOTATION_DIRECTORIES="spec"
export DISABLE_AUTO_TITLE=true
export _Z_OWNER=$USER

# Path to your oh-my-zsh installation.
export ZSH=/Users/kshah/.oh-my-zsh
export TERM=screen-256color

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# POWERLEVEL9K_MODE='awesome-fontconfig'
POWERLEVEL9K_MODE='awesome-patched'
ZSH_THEME="powerlevel9k/powerlevel9k"

# POWERLEVEL9K_IP_INTERFACE='en0'
# POWERLEVEL9K_PUBLIC_IP_HOST='http://ident.me'

# zsh tmux settings
ZSH_TMUX_AUTOSTART='true'

## Powerlevel9k Settings
POWERLEVEL9K_HISTORY_BACKGROUND='green'

POWERLEVEL9K_SHORTEN_STRATEGY="truncate_middle"
POWERLEVEL9K_SHORTEN_DIR_LENGTH=4

POWERLEVEL9K_PROMPT_ON_NEWLINE=true

POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=''
POWERLEVEL9K_MULTILINE_SECOND_PROMPT_PREFIX="%F{red} \Uf1d0 %f %F{yellow
}â¯ "

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status history)

export ZSH=$HOME/.oh-my-zsh
export UPDATE_ZSH_DAYS=7
COMPLETION_WAITING_DOTS="true"

# # Refresh Function - https://babushk.in/posts/renew-environment-tmux.html
# if [ -n "$TMUX" ]; then
#   function refresh {
#     export $(tmux show-environment | grep "^SSH_AUTH_SOCK")
#     export $(tmux show-environment | grep "^DISPLAY")
#   }
# else
#   function refresh { }
# fi

# # Then, I define a preexec hook that calls refresh before each new command that gets executed:
# function preexec {
#     refresh
# }

# POWERLEVEL9K_TIME_FORMAT="%D{%T | %m.%d.%y}"
##

# Default username to hide "user@hostname" info
DEFAULT_USER="kshah"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE=~/.zsh_history
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    brew
    common-aliases
    git
    jira
    osx
    pip
    repo
    sudo
    taskwarrior
    tmux
    wd
    web-search
    zsh-autosgestions
    zsh-complettions
)

source $ZSH/oh-my-zsh.sh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

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

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#

# Example aliases
#alias zshconfig="code ~/.zshrc"
#alias ohmyzsh="code ~/.oh-my-zsh"
# alias EDITOR=nvim

# Use vi mode
bindkey -v

# Vi mode settings
# Better searching in command mode
bindkey -M vicmd '?' history-incremental-search-backward
bindkey -M vicmd '/' history-incremental-search-forward

# Beginning search with arrow keys
bindkey "^[OA" up-line-or-beginning-search
bindkey "^[OB" down-line-or-beginning-search
bindkey -M vicmd "k" up-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search

# Easier, more vim-like editor opening
bindkey -M vicmd v edit-command-line

# Make Vi mode transitions faster (KEYTIMEOUT is in hundredths of a second)
export KEYTIMEOUT=1

# Updates editor information when the keymap changes.
function zle-keymap-select() {
  zle reset-prompt
  zle -R
}

zle -N zle-keymap-select

#Powerline
if [ -d "$HOME/Library/Python/2.7/bin" ]; then
    PATH="$HOME/Library/Python/2.7/bin:$PATH"
fi

function my_remote_status() {
  if [[ -n "$(command git show-ref origin/$(git_current_branch) 2> /dev/null)"  ]]; then
    echo "$(git_commits_ahead)$(git_commits_behind)"
  fi
}

# Adapted from git_prompt_info(): oh-my-zsh/lib/git.zsh
function my_git_prompt() {
  local ref
  if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" != "1" ]]; then
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX$(git_current_branch)$(git_prompt_status)$ZSH_THEME_GIT_PROMPT_SUFFIX $(my_remote_status)"
  fi
}

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[white]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[white]%}]%{$reset_color%}"

ZSH_THEME_GIT_COMMITS_AHEAD_PREFIX="%{$fg[magenta]%}?"
ZSH_THEME_GIT_COMMITS_AHEAD_SUFFIX=" %{$reset_color%}"
ZSH_THEME_GIT_COMMITS_BEHIND_PREFIX="%{$fg[cyan]%}?"
ZSH_THEME_GIT_COMMITS_BEHIND_SUFFIX=" %{$reset_color%}"

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}+"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[red]%}*"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}-"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%}>"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%}?"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%}?"
ZSH_THEME_GIT_PROMPT_STASHED="%{$fg[yellow]%}?"
ZSH_THEME_GIT_PROMPT_SHA_BEFORE="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$reset_color%}"

local timestamp='%{$reset_color%}[%{$fg[yellow]%}%*%{$reset_color%}]'
local git='$(my_git_prompt)$(git_prompt_short_sha)'

if [[ -n $SSH_CONNECTION ]]; then
  local pwd='%{$fg[magenta]%}%n@%m %{$fg[blue]%}%~%{$reset_color%}'
else
  local pwd='%{$fg[blue]%}$(shrink_path -f)%{$reset_color%}'
fi

PROMPT="${timestamp} ${pwd} ${git}
%(?..%{$fg[red]%})%B$%b%{$reset_color%} "

function vi_mode_prompt_info() {
  echo "${${KEYMAP/vicmd/[% NORMAL]%}/(main|viins)/[% INSERT]%} "
}
RPROMPT='$(vi_mode_prompt_info)'

repository_root="$HOME/Library/Python/2.7/lib/python/site-packages"
. $repository_root/powerline/bindings/zsh/powerline.zsh

export PATH=$PATH:/Users/kshah/bin

autoload bashcompinit && bashcompinit
