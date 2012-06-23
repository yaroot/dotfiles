#!/bin/zsh

#{{{ $HOME/.zshrc
#
# if [ -z "$DISPLAY" ] && [ $(tty) = /dev/tty1 ]; then
#   if [ -x "$HOME/.local/bin/dwm" ]; then
#     (startx &); logout
#     # (startx xfce &); logout
#   fi
# fi
#
# source $HOME/.dotfiles/zshrc
#
# export PATH="$HOME/.cabal/bin:$PATH"
# export PATH="$HOME/.rbenv/bin:$PATH"
# export PATH="$HOME/repos/n/bin:$PATH"
#
# export N_PREFIX="$HOME/.nodes"
# export PATH="$N_PREFIX/n/current/bin:$PATH"
# export NODE_PATH="$N_PREFIX/n/current/lib/node_modules" # npm -g root
# 
# export VIRTUAL_ENV_DISABLE_PROMPT=1
# source $HOME/.pythons/versions/27/bin/activate
#
# source $HOME/.dotfiles/zshrc
# 
# eval "$(npm completion 2>/dev/null)"
# eval "$(rbenv init -)"
#
#}}}

#{{{ transparent for xterm
# if [ $TERM = "xterm" ]; then
#   [ -n "$WINDOWID" ] && transset-df -i $WINDOWID >/dev/null
# fi
#}}}

#{{{ Environment variables
export PAGER=`\which less`
export EDITOR=`\which vim`
\which lesspipe.sh > /dev/null && export LESSOPEN="|lesspipe.sh %s"
\which lesspipe > /dev/null && export LESSOPEN="|lesspipe %s"

if [ -f "${HOME}/.keychain/${HOST}-sh" ]; then
  source "${HOME}/.keychain/${HOST}-sh"
fi

if [ "x${LANG}" != "x" ]; then
  if [ "x${LANGUAGE}" = "x" ]; then
    export LANGUAGE="$LANG"
  fi
  if [ "x${LC_ALL}" = "x" ]; then
    export LC_ALL="$LANG"
  fi
fi


# update SSH_AUTH_SOCK
# if [ "x$TMUX" != "x" ]; then
#   local sock_path=$(tmux showenv | grep '^SSH_AUTH_SOCK')
#   if [ "x$sock_path" != "x" ]; then
#     eval "${sock_path}; export SSH_AUTH_SOCK;"
#   fi
# fi

export PATH="$HOME/.bin:$HOME/.local/bin:$PATH"


ipad_ua='Mozilla/5.0 (iPad; U; CPU OS 4_3_3 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2 Safari/6533.18.5'
firefox_ua='Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20100101 Firefox/14.0'
chrome_ua='Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/536.11 (KHTML, like Gecko) Chrome/20.0.1132.42'

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
#zstyle :compinstall filename "$HOME/.zshrc"

autoload -U compinit
if [ -d "$HOME/._zshcomp" ]; then
  fpath=($fpath $HOME/._zshcomp)
fi
if [ -d "$HOME/repos/zsh-completions" ]; then
  fpath=($fpath $HOME/repos/zsh-completions)
fi
compinit
autoload -U colors
colors
autoload -U zmv
autoload -U zargs

# ESC-v brings you $EDITOR !
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

#autoload -U promptinit
#promptinit
#autoload -Uz vcs_info
#zstyle ':vcs_info:*' enable git
#zstyle ':vcs_info:git:*' formats '[%b]'
#}}}

# prompts {{{
#autoload -U promptinit
#promptinit
#prompt walters

if [ $TERM = dumb ]; then
  PS1="> "
  PS2="%_ $PS1"
  PS3="?# $PS1"
  ZCALCPROMPT='%1v> '
else
  # » for user and # for root. green if the previous command returned
  # 0, red otherwise.
  # PS1="%(0?.%F{green}.%F{red})%(0#.#.»)%f "

  # make gentoo prefix looks different
  # if [ $EPREFIX ]; then
  #   case $PATH in
  #     *gentoo* )
  #       RPS1="%F{red}§%m§ %F{green}%~" ;;
  #     * )
  #       RPS1="%F{red}%m %F{green}%~" ;;
  #   esac
  # fi

  PS1='%(0?.%F{green}.%F{red})%(0#.#.>)%f '
  RPS1='%F{red}%m %F{green}%~'
  PS2='%B%F{white}%_%f%(0?.%F{green}.%F{red})%(0#.#.>)%f '
  RPS2=$RPS1
  PS3='%B%F{white}?#%f%(0?.%F{green}.%F{red})%(0#.#.>)%f '
  RPS3=$RPS1
  ZCALCPROMPT='%F{blue}%1v>%f '
fi
#}}}

#{{{ alias
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

if [ `uname -s` = 'Darwin' ]; then
  alias ls="ls -G"
elif [ `uname -s` = 'Linux' ] || [ `uname -o` = 'Cygwin' ]; then
  alias ls="ls --color=auto"
else
  alias ls="ls -G"
fi

alias more='less'

if [ "$TERM" = 'screen' ] || [ "$TERM" = 'xterm' ]; then
  alias mutt='TERM=xterm-256color mutt'
fi

\which colordiff &> /dev/null
if [ $? -eq 0  ]; then
  alias diff='colordiff'
fi

alias -g L='| less'
alias -g G='| grep --color=auto -n'
alias -g H='| head'
alias grep='grep --color=auto -n'
alias iftop='iftop -B'
alias hdtemp='echo `netcat localhost 7634`'
alias pc='proxychains'
alias vbox='VirtualBox &'
alias tty-clock='tty-clock -c'
alias rd='rdesktop -u administrator -g 1024x768 -x m -r clipboard'
#alias rdd='rdesktop -u administrator -g 1600x1000 -r sound:local -r clipboard -5 -x 0x80 -z -b'
alias rdd='rdesktop -u administrator -g 1600x1000 -r clipboard -5 -x 0x80 -z -b'
alias xf='xfreerdp -u administrator -g 1024x768 -x m -z'
alias xff='xfreerdp -u administrator -g 1600x1000 -x l -z'
alias pss='ps aux | grep '
alias vacuumsqlite="find . -name '*.sqlite' -exec sqlite3 {} 'VACUUM' \;"
alias cpl='cpulimit -zl 70 -p '
alias lock='xscreensaver-command -lock'
alias tpoff='synclient TouchpadOff=1'
alias tpon='synclient TouchpadOff=0'
#alias emacs='emacs -nw'
alias ht='htop'
alias sdo='sudo su ${USER} -c'
alias s='sudo '
alias g='git'
alias v='vim'
alias vd='vimdiff'
alias gd='gvimdiff'
alias wifi='wicd-curses'
alias weathersh='curl http://weather.noaa.gov/pub/data/observations/metar/decoded/ZSSS.TXT'
alias weatherbj='curl http://weather.noaa.gov/pub/data/observations/metar/decoded/ZBAA.TXT'
alias ytdl="youtube-dl -o '%(stitle)s.%(ext)s'"
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
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*' use-cache on
zstyle ':completion:*:approximate:*' max-errors 1 numeric

#compdef _pacman {pacman-color,clyde,powerpill,bauerbill}=pacman
#compdef _pacman parsablepackagesize=pacman
#compdef _cp cpf=cp
#compdef _mkdir mkf=mkdir
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
  local word="$1"
  shift
  find . -iname "*${word}*" "$@"
}

function quiet()
{
  "$@" 2>&1 > /dev/null
}

function git_new_bare()
{
  if [ -z "$1" ]; then
    echo >2 'Usage: git_new ${repo_name}'
    exit 1
  fi

  local base_dir=`pwd`
  local repo_name="$1"
  mkdir -p ${repo_name}
  cd ${repo_name}
  git init --bare
  cd "${base_dir}"
}

function git_push_all()
{
  for remote in `git remote`; do
    git push "$remote" $@
  done
}


function gitio()
{
  local url="$1"
  local code="$2"
  if [ "x${code}" != "x" ]; then
    code="-F \"code=${code}\""
  fi
  eval "curl -i http://git.io -F \"url=${url}\" $code"
}

function upload_one_pic_imgur()
{
  # API Key provided by Alan@imgur.com
  local API_KEY="b3625162d3418ac51a9ee805b1840452"
  local API_URL="http://imgur.com/api/upload.xml"

  local FILE="$1"
  local IMGUR_RESPONSE

  if [ "x${IMGUR_API_KEY}" != "x" ]; then
    API_KEY="$IMGUR_API_KEY"
  fi

  IMGUR_RESPONSE=`curl -F "key=$API_KEY" -F "image=@${FILE}" $API_URL`

  echo ">>> $FILE"
  echo ">>>" `echo $IMGUR_RESPONSE | \grep -E -o '<original_image>(.+)</original_image>' | \grep -E -o 'http://i.imgur.com/[^<]*'`
}

function imgur_upload()
{
  for img in "$@"; do
    upload_one_pic_imgur "$img"
  done
}

function currency_convert()
{
  local amo=$1
  local from=$2
  shift;shift;

  for i in $@; do
    curl -sL "http://www.google.com/finance/converter?a=$amo&from=$from&to=$i&hl=es" | sed '/res/!d;s/<[^>]*>//g'
  done
}

#}}}

