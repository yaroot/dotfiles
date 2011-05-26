
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

bindkey -v # vim like key binding
zstyle :compinstall filename "$HOME/.zshrc"

autoload -U compinit colors zmv zargs #promptinit
compinit
#promptinit
colors
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
    case $PATH in
        *gentoo* )
            RPS1="%F{red}§%m§ %F{green}%~" ;;
        * )
            RPS1="%F{red}%m %F{green}%~" ;;
    esac

    PS1="%(0?.%F{green}.%F{red})%(0#.#.>)%f "
    PS2="%B%F{white}%_%f%(0?.%F{green}.%F{red})%(0#.#.>)%f "
    RPS2=$RPS1
    PS3="%B%F{white}?#%f%(0?.%F{green}.%F{red})%(0#.#.>)%f "
    RPS3=$RPS1
    ZCALCPROMPT="%F{blue}%1v>%f "
fi

# http://aperiodic.net/phil/prompt/prompt.txt
#function precmd {
#
#    local TERMWIDTH
#    (( TERMWIDTH = ${COLUMNS} - 1 ))
#
#    # Truncate the path if it's too long.
#    PR_FILLBAR=""
#    PR_PWDLEN=""
#
#    local promptsize=${#${(%):---(%n@%m:%l)---()--}}
#    local pwdsize=${#${(%):-%~}}
#
#    if [[ "$promptsize + $pwdsize" -gt $TERMWIDTH ]]; then
#	    ((PR_PWDLEN=$TERMWIDTH - $promptsize))
#    else
#	PR_FILLBAR="\${(l.(($TERMWIDTH - ($promptsize + $pwdsize)))..${PR_HBAR}.)}"
#    fi
#
#
#    ###
#    # Get APM info.
#
##    if which ibam > /dev/null; then
##	PR_APM_RESULT=`ibam --percentbattery`
##    elif which apm > /dev/null; then
##	PR_APM_RESULT=`apm`
##    fi
#
#    if [ -d ~/.bin ] && [ -x ~/.bin/battery.lua ] ; then
#        PR_APM_RESULT=`~/.bin/battery.lua`
#    fi
#}
#
#
#setopt extended_glob
#preexec () {
#    if [[ "$TERM" == "screen" ]]; then
#	local CMD=${1[(wr)^(*=*|sudo|-*)]}
#	echo -n "\ek$CMD\e\\"
#    fi
#}
#
#
#setprompt () {
#    ###
#    # Need this so the prompt will work.
#
#    setopt prompt_subst
#
#
#    ###
#    # See if we can use colors.
#
#    autoload colors zsh/terminfo
#    if [[ "$terminfo[colors]" -ge 8 ]]; then
#	colors
#    fi
#    for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
#	eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
#	eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
#	(( count = $count + 1 ))
#    done
#    PR_NO_COLOUR="%{$terminfo[sgr0]%}"
#
#
#    ###
#    # See if we can use extended characters to look nicer.
#
#    typeset -A altchar
#    set -A altchar ${(s..)terminfo[acsc]}
#    PR_SET_CHARSET="%{$terminfo[enacs]%}"
#    PR_SHIFT_IN="%{$terminfo[smacs]%}"
#    PR_SHIFT_OUT="%{$terminfo[rmacs]%}"
#    PR_HBAR=${altchar[q]:--}
#    PR_ULCORNER=${altchar[l]:--}
#    PR_LLCORNER=${altchar[m]:--}
#    PR_LRCORNER=${altchar[j]:--}
#    PR_URCORNER=${altchar[k]:--}
#
#
#    ###
#    # Decide if we need to set titlebar text.
#
#    case $TERM in
#	xterm*)
#	    PR_TITLEBAR=$'%{\e]0;%(!.-=*[ROOT]*=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\a%}'
#	    ;;
#	screen)
#	    PR_TITLEBAR=$'%{\e_screen \005 (\005t) | %(!.-=[ROOT]=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\e\\%}'
#	    ;;
#	*)
#	    PR_TITLEBAR=''
#	    ;;
#    esac
#
#
#    ###
#    # Decide whether to set a screen title
#    if [[ "$TERM" == "screen" ]]; then
#	PR_STITLE=$'%{\ekzsh\e\\%}'
#    else
#	PR_STITLE=''
#    fi
#
#
#    ###
#    # APM detection
#
## XXX ibam need to be updated
##    if which ibam > /dev/null; then
##	PR_APM='$PR_RED${${PR_APM_RESULT[(f)1]}[(w)-2]}%%(${${PR_APM_RESULT[(f)3]}[(w)-1]})$PR_LIGHT_BLUE:'
##    elif which apm > /dev/null; then
##	PR_APM='$PR_RED${PR_APM_RESULT[(w)5,(w)6]/\% /%%}$PR_LIGHT_BLUE:'
##    else
##	PR_APM=''
##    fi
#
#    if [ -d ~/.bin ] && [ -x ~/.bin/battery.lua ] ; then
#        #PR_APM_RESULT=`~/.bin/battery.lua`
#        PR_APM='$PR_RED${${PR_APM_RESULT[(f)1]}[(w)-2]}%%$PR_LIGHT_BLUE:'
#    else
#        PR_APM=''
#    fi
#
#    ###
#    # Finally, the prompt.
#
#    PROMPT='$PR_SET_CHARSET$PR_STITLE${(e)PR_TITLEBAR}\
#$PR_CYAN$PR_SHIFT_IN$PR_ULCORNER$PR_BLUE$PR_HBAR$PR_SHIFT_OUT(\
#$PR_GREEN%(!.%SROOT%s.%n)$PR_GREEN@%m:%l\
#$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_CYAN$PR_HBAR${(e)PR_FILLBAR}$PR_BLUE$PR_HBAR$PR_SHIFT_OUT(\
#$PR_MAGENTA%$PR_PWDLEN<...<%~%<<\
#$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_CYAN$PR_URCORNER$PR_SHIFT_OUT\
#
#$PR_CYAN$PR_SHIFT_IN$PR_LLCORNER$PR_BLUE$PR_HBAR$PR_SHIFT_OUT(\
#%(?..$PR_LIGHT_RED%?$PR_BLUE:)\
#${(e)PR_APM}$PR_YELLOW%D{%H:%M}\
#$PR_LIGHT_BLUE:%(!.$PR_RED.$PR_WHITE)%#$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
#$PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
#$PR_NO_COLOUR '
#
#    RPROMPT=' $PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_BLUE$PR_HBAR$PR_SHIFT_OUT\
#($PR_YELLOW%D{%a,%b%d}$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_CYAN$PR_LRCORNER$PR_SHIFT_OUT$PR_NO_COLOUR'
#
#    PS2='$PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
#$PR_BLUE$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT(\
#$PR_LIGHT_GREEN%_$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
#$PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT$PR_NO_COLOUR '
#}
#
#setprompt
### }}}

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
alias ll="ls -ahl ${LS_OPTION}"
alias la="ls -hl ${LS_OPTION}"

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

