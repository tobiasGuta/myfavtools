# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# Variable to store target IP (initialized as empty)
TARGET_IP=""

# Function to set target IP
target_ip() {
    TARGET_IP="$1"
}

# Function to get VPN IP
get_vpn_ip() {
    vpn_ip=$(ip a show tun0 2>/dev/null | grep 'inet ' | awk '{print $2}' | cut -d'/' -f1)
    if [ -n "$vpn_ip" ]; then
        echo "🔒 $vpn_ip"
    else
        echo "🔒 Disconnected "
    fi
}

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

# Configure prompt with custom display for VPN and Target IP
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='\[\033[0;33m\]◖(\[\033[01;32m\]\u@\h\[\033[0;33m\])◗ \[\033[01;35m\]❰\w❱ \[\033[0;32m\](\t)\[\033[0;33m\] $(get_vpn_ip) $(if [ -n "$TARGET_IP" ]; then echo "💀 \[\033[01;31m\]$TARGET_IP\[\033[0;33m\]"; fi)\n\[\033[0;33m\]❯❯❯ \[\033[0m\]'
else
    PS1='\[\033[0;33m\]◖(\[\033[01;32m\]\u@\h\[\033[0;33m\])◗ \[\033[01;35m\]❰\w❱ \[\033[0;32m\](\t)\[\033[0;33m\] $(get_vpn_ip) $(if [ -n "$TARGET_IP" ]; then echo "💀 \[\033[01;31m\]$TARGET_IP\[\033[0;33m\]"; fi)\n\$ '
fi






unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# Alias definitions
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export PATH=$PATH:~/go/bin
export PATH=$PATH:/usr/local/go/bin

. "$HOME/.cargo/env"
