# ~/.bashrc: executed by bash(1) for non-login shells.

export PS1='\h:\w\$ '
umask 022

# You may uncomment the following lines if you want `ls' to be colorized:
# export LS_OPTIONS='--color=auto'
# eval `dircolors`
# alias ls='ls $LS_OPTIONS'
# alias ll='ls $LS_OPTIONS -l'
# alias l='ls $LS_OPTIONS -lA'
#
# Some more alias to avoid making mistakes:
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'
alias wine=/opt/cxoffice/bin/wine
function psjag() {
    ps aux | grep -i \.ex[e] | grep -v defunct
    ps aux | egrep -i 'fi[m]|nc[r]'
}
function setdisplay() {
    pushd /tmp/.X11-unix
    TMPDISPLAY=`ls -1 * | head`
    DISPLAYNUM=${TMPDISPLAY#X}
    export DISPLAY=:${DISPLAYNUM}
    popd
}
