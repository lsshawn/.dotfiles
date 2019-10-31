# Path to oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME=""

# TMUX
# Automatically start tmux
ZSH_TMUX_AUTOSTART=true

# Automatically connect to a previous session if it exists
ZSH_TMUX_AUTOCONNECT=true

# Enable command auto-correction.
ENABLE_CORRECTION="true"

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  node
  brew
  tmux
  zsh-autosuggestions
)

# User configuration
# Hide user@hostname if it's expected default user
DEFAULT_USER="ss"
prompt_context(){}

# === FZF === #

# Setting rg as the default source for fzf
source /usr/share/fzf/completion.zsh && source /usr/share/fzf/key-bindings.zsh
[ -f ~/.fzf.zhs ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPS="--extended"
export FZF_DEFAULT_COMMAND='rg --files'
# Apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Set location of z installation
. /home/ss/scripts/z/z.sh

## FZF FUNCTIONS ##

# fo [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fo() {
  local files
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

# fh [FUZZY PATTERN] - Search in command history
fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}

# fbr [FUZZY PATTERN] - Checkout specified branch
# Include remote branches, sorted by most recent commit and limited to 30
fgb() {
  local branches branch
  branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# tm [SESSION_NAME | FUZZY PATTERN] - create new tmux session, or switch to existing one.
# Running `tm` will let you fuzzy-find a session mame
# Passing an argument to `ftm` will switch to that session if it exists or create it otherwise
ftm() {
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
  if [ $1 ]; then
    tmux $change -t "$1" 2>/dev/null || (tmux new-session -d -s $1 && tmux $change -t "$1"); return
  fi
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) &&  tmux $change -t "$session" || echo "No sessions found."
}

# tm [SESSION_NAME | FUZZY PATTERN] - delete tmux session
# Running `tm` will let you fuzzy-find a session mame to delete
# Passing an argument to `ftm` will delete that session if it exists
ftmk() {
  if [ $1 ]; then
    tmux kill-session -t "$1"; return
  fi
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) &&  tmux kill-session -t "$session" || echo "No session found to delete."
}

# fuzzy grep via rg and open in vim with line number
fgr() {
  local file
  local line

  read -r file line <<<"$(rg --no-heading --line-number $@ | fzf -0 -1 | awk -F: '{print $1, $2}')"

  if [[ -n $file ]]
  then
     vim $file +$line
  fi
}

# Enabled zsh-autosuggestions
#source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Set default editor to nvim
export EDITOR='nvim'

# Enabled true color support for terminals
export NVIM_TUI_ENABLE_TRUE_COLOR=1

# Aliases
alias vim="nvim"
alias top="vtop --theme=wizard"
alias ls="colorls -lA --sd"

source $ZSH/oh-my-zsh.sh

# Set Spaceship as prompt
autoload -U promptinit; promptinit
prompt spaceship
SPACESHIP_PACKAGE_SHOW=false
SPACESHIP_NODE_SHOW=false
SPACESHIP_GIT_STATUS_STASHED=''

# Aliases
alias vim="nvim"
alias top="vtop --theme=wizard"
export PATH="/home/ss/.gem/ruby/2.6.0/bin:$PATH"
alias ls="colorls -lA --sd"

alias ide="~/scripts/ide"

alias dotfiles="/usr/bin/env git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
alias dotfiles="/usr/bin/env git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"

alias buckle="bucklespring.buckle -g 20 hrtf = true"
alias sshawn="cd ~/projects/sshawn"
alias cupbots="cd ~/projects/cupbots-api"
alias proj="cd ~/projects"
alias t="~/scripts/todo.txt-cli/todo.sh"
alias pomo="~/scripts/pomogoro/pomogoro --config ~/scripts/pomogoro/config.toml"
alias jou="~/scripts/daily-journal"
alias csv2tab="~/scripts/csv2tab.sh"
alias note="nvim ~/projects/sshawn/content/quickNote.md"
alias content="cd ~/projects/sshawn/content"
alias post="~/scripts/writeNewPost"
alias vim="nvim"
alias vi="nvim"

export NVIMINIT=~/.config/nvim/init.vim
export NVIMPLUGIN=~/.config/nvim/plugins.vim

# remaps CAPSLOCK to ESC
setxkbmap -option caps:swapescape

# auto completion for todo.txt
if [ -f ~/scripts/todo.txt-cli/todo_completion ]; then
	. ~/scripts/todo.txt-cli/todo_completion
fi

if [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi

function countdown(){
   date1=$((`date +%s` + $1*60));
   while [ "$date1" -ge `date +%s` ]; do
     echo -ne "$(date -u --date @$(($date1 - `date +%s`)) +%H:%M:%S)\r";
     sleep 0.1
   done
   aplay /usr/share/sounds/deepin/stereo/complete-copy.wav
}

# https://github.com/numberoverzero/brainfm
export BRAINFM_SID="s%3ABkirvTS3y2vpW4IF4IZLbG4k9rzA858B.gxGA6TTs2lRYmBjyxRKBClgDTSgc%2BKT9uSYo40SsiX8"

