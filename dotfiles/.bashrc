#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W\$ '

# Enable starship prompt
eval "$(starship init bash)"

# Custom gcc path
#export PATH=$PATH:/home/bzgec/gcc-arm-none-eabi/bin

RM_SSH_KEY () {
  ssh-keygen -f "/home/bzgec/.ssh/known_hosts" -R "192.168.64.2"
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
