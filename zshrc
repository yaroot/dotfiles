
#{{{ Environment variables
export PAGER=`which less`
export LESSOPEN="|lesspipe.sh %s"
export EDITOR=`which vim`

source $HOME/.myenvrc
#}}}

#{{{ Settings
# history
HISTFILE=~/.histfile
HISTSIZE=2048
SAVEHIST=$HISTSIZE

setopt extendedglob
setopt interactivecomments
setopt completeinword
setopt noclobber
setopt nobeep
setopt chaselinks
setopt pushdignoredups
setopt histignorealldups
setopt correctall
setopt promptsubst
setopt braceccl
setopt appendhistory
setopt autocd
#setopt nomatch
unsetopt notify

bindkey -v # vim fellow
zstyle :compinstall filename "$HOME/.zshrc"

autoload -U compinit
compinit
autoload -U colors
colors
autoload -U zmv
autoload -U zargs
#autoload -U promptinit
#promptinit
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '[%b]'
#}}}

# prompts {{{
#autoload -U promptinit
#promptinit
#prompt walters

if [[ $TERM == dumb ]]; then
    PS1="> "
    PS2="%_ $PS1"
    PS3="?# $PS1"
    ZCALCPROMPT='%1v> '
else
    # » for user and # for root. green if the previous command returned
    # 0, red otherwise.
    # PS1="%(0?.%F{green}.%F{red})%(0#.#.»)%f "

    # make gentoo prefix looks different
    #if [ $EPREFIX ]; then
#    case $PATH in
#        *gentoo* )
#            RPS1="%F{red}§%m§ %F{green}%~" ;;
#        * )
#            RPS1="%F{red}%m %F{green}%~" ;;
#    esac

    PS1='%(0?.%F{green}.%F{red})%(0#.#.>)%f '
    RPS1='%F{red}%m %F{blue}${vcs_info_msg_0_} %F{green}%~'
    PS2='%B%F{white}%_%f%(0?.%F{green}.%F{red})%(0#.#.>)%f '
    RPS2=$RPS1
    PS3='%B%F{white}?#%f%(0?.%F{green}.%F{red})%(0#.#.>)%f '
    RPS3=$RPS1
    ZCALCPROMPT='%F{blue}%1v>%f '
fi

#{{{ alias
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

LS_OPTION='--color=auto'

ls ${LS_OPTION} / &> /dev/null
if [ $? -eq 0 ]; then
    # do nothing
else
    LS_OPTION='-G'
fi

alias ls="ls ${LS_OPTION}"

alias more='less'


which colordiff &> /dev/null
if [ $? -eq 0  ]; then
    alias diff='colordiff'
fi
alias -g L='| less'
alias -g G='| grep --color=auto -n'
alias grep='grep --color=auto -n'
alias iftop='iftop -B'
alias hdtemp='netcat localhost 7634'
alias pc='proxychains'
alias vbox='VirtualBox &'
alias kb="xmodmap -e 'keycode 66 = Escape' -e 'clear Lock'"
alias tty-clock='tty-clock -c'
alias rd='rdesktop -u administrator -g 1024x768 -x m -r clipboard'
#alias rdd='rdesktop -u administrator -g 1600x1000 -r sound:local -r clipboard -5 -x 0x80 -z -b'
alias rdd='rdesktop -u administrator -g 1600x1000 -r clipboard -5 -x 0x80 -z -b'
alias xf='xfreerdp -u administrator -g 1024x768 -x m -z'
alias xff='xfreerdp -u administrator -g 1600x1000 -x l -z'
alias pss='ps aux | grep '
alias cpl='cpulimit -zl 70 -p '
alias lock='xscreensaver-command -lock'
alias tpoff='synclient TouchpadOff=1'
alias tpon='synclient TouchpadOff=0'
#alias emacs='emacs -nw'
alias ht='htop'
alias sdo='sudo su ${USER} -c'
alias s='sudo'
alias g='git'
alias gs='git status'
alias fuckgfw='ssh -CD'
alias v='gvim'
alias vd='vimdiff'
alias gd='gvimdiff'
alias wifi='wicd-curses'
alias getweather='curl http://weather.noaa.gov/pub/data/observations/metar/decoded/ZSSS.TXT'
alias m="man"
alias p="pinfo"

# suffix alias
alias -s git='git clone'

# dir alias
hash -d vim=$HOME/.vim
#}}}

#{{{ completion configuration
zstyle ':completion:*' group-name ''
zstyle ':completion:*' ignore-parents parent pwd
zstyle ':completion:*:(rm|vi|vim):*' ignore-line true
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%U%Bno matches: %d%b%u'
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:kill:*' menu yes select
zstyle ':completion:*:kill:*:processes' command 'ps wx -o pid,tty,time,args'
zstyle ':completion:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:processes-names' command 'ps -wxho command'

compdef _pacman {pacman-color,clyde,powerpill,bauerbill}=pacman
compdef _pacman parsablepackagesize=pacman
compdef _cp cpf=cp
compdef _mkdir mkf=mkdir
compctl -g '/etc/rc.d/*(:t)' dstart
compctl -g '/var/run/daemons/*(:t)' dstop drestart
### }}}

#{{{ Functions

function precmd()
{
    vcs_info
}


function x()
{
	if [ -f "$1" ] ; then
		case "$1" in
			*.tar.bz2)  tar xjf "$1"      ;;
			*.tar.gz)   tar xzf "$1"      ;;
			*.tar.bz)   tar xzf "$1"      ;;
			*.tar.Z)    tar xzf "$1"      ;;
			*.bz2)      bunzip2 "$1"      ;;
			*.rar)      unrar x "$1"      ;;
			*.gz)       gunzip "$1"       ;;
			*.jar)      unzip "$1"        ;;
			*.tar)      tar xf "$1"       ;;
			*.tbz2)     tar xjf "$1"      ;;
			*.tgz)      tar xzf "$1"      ;;
			*.zip)      unzip "$1"        ;;
			*.Z)        uncompress "$1"   ;;
			*.7z)       7z x "$1"   ;;
			*)          echo "'$1' cannot be extracted." ;;
		esac
	else
		echo "'$1' is not a valid archive."
	fi
}

function fin()
{
    find . -iname "*$1*"
}

#}}}

