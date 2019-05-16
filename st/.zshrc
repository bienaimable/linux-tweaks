# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/bienaimable/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
export LESSOPEN="| /usr/bin/lesspipe %s";
export LESSCLOSE="/usr/bin/lesspipe %s %s";
countdown() {
    MIN=$1;for ((i=MIN*60;i>=0;i--));do echo -ne "\r$(date -d"0+$i sec" +%H:%M:%S)";sleep 1;done
}
beep() {
    paplay /usr/share/sounds/freedesktop/stereo/complete.oga
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
