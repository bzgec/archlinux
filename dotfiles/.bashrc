#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W\$ '

################################################################################
# Default .bashrc for ubuntu
#   Copied from: https://gist.github.com/marioBonales/1637696
################################################################################
# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
################################################################################

################################################################################
# Starship
################################################################################
##################################################
# Terminal title
##################################################
# Reset prompt command
PROMPT_COMMAND=''

# Set termTitle to empty string - if set it is used as terminal title
termTitle=''

# Set tab title funtion
# https://makandracards.com/makandra/21369-bash-setting-the-title-of-your-terminal-tab
# https://unix.stackexchange.com/questions/216953/show-only-current-and-parent-directory-in-bash-prompt
function tabTitleSet {
  # Check if termTitle var is set
  if [[ ! "$termTitle" ]]; then
    # termTitle var not set, check if we are trying to set it
    if [ -z "$1" ]; then
      # Set tab title as current directory
      # title=${PWD##*/}  # Current directory
      # title=${PWD}  # Current directory - full path
      title=$(basename $(dirname "$PWD"))/$(basename "$PWD")  # Current dir and parent dirr
    else
      # set termTitle var
      termTitle=$1  # First param
      title=$1  # first param
    fi
  else
    title=$termTitle
  fi

  echo -ne "\033]0;$title\007"
}

function tabTitleReset {
  termTitle=''
}

# Set cb function when command is executed in terminal
# https://starship.rs/advanced-config/#change-window-title
starship_precmd_user_func="tabTitleSet"

##################################################
# Enable starship prompt
##################################################
eval "$(starship init bash)"
################################################################################


################################################################################
# HSTR configuration - add this to ~/.bashrc
################################################################################
alias hh=hstr                    # hh to be alias for hstr
export HSTR_CONFIG=hicolor       # get more colors
shopt -s histappend              # append new history items to .bash_history
#export HISTCONTROL=ignorespace   # leading space hides commands from history
export HISTFILESIZE=10000        # increase history file size (default is 500)
export HISTSIZE=${HISTFILESIZE}  # increase history size (default is 500)
# ensure synchronization between bash memory and history file
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"
# if this is interactive shell, then bind hstr to Ctrl-r (for Vi mode check doc)
if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hstr -- \C-j"'; fi
# if this is interactive shell, then bind 'kill last command' to Ctrl-x k
if [[ $- =~ .*i.* ]]; then bind '"\C-xk": "\C-a hstr -k \C-j"'; fi
################################################################################

# Set nvim as a MANPAGER
export MANPAGER="nvim -c 'set ft=man' -"

# Set Alacritty as TERM
export TERM=alacritty

################################################################################
# Change path
################################################################################
# Custom gcc path
export PATH="$PATH":~/gcc-arm-none-eabi/bin

# Python pip scripts
export PATH="$PATH":~/.local/bin
################################################################################

RM_SSH_KEY () {
  ssh-keygen -f "~/.ssh/known_hosts" -R "192.168.64.2"
}

SSH_PI () {
  ssh pi@192.168.64.2
}

NUCLEO_UART_115200() {
  minicom -D /dev/ttyACM0 -b 115200
}

git_log() {
  git log --pretty=format:'%C(yellow)%h %Cred%ad %C(cyan)%an%C(auto)%d %C(reset)%s' --date=format:'%Y/%m/%d %H:%M:%S' --all --graph
}

# Set `w` to set new background picture
alias w='nitrogen --set-zoom-fill --random ~/wallpapers-collection'

alias light="~/.config/themeSwitcher.py --light"
alias dark="~/.config/themeSwitcher.py --dark"

alias UPDATE_MIRRORLIST="sudo reflector --latest 20 --protocol http --protocol https --sort rate --save /etc/pacman.d/mirrorlist"

alias killAllProc="~/.config/killAllProc.sh"

alias keymap="~/.config/keymap/keymap.sh"

# First parameter is password length
GEN_PASS () {
  openssl rand -base64 $1
}

# First parameter is password length
GEN_PASS_SIMP () {
  openssl rand -base64 $1 | tr -dc '[:alnum:]\n\r'
}
