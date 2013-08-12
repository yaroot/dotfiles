#!/bin/zsh

#{{{ transparent for xterm
# if [ $TERM = "xterm" ]; then
#   which transset-df 2>&1 /dev/null && [ -n "$WINDOWID" ] && transset-df -i $WINDOWID >/dev/null
# fi
#}}}

#{{{ Environment variables
export PAGER=`which less`
export EDITOR=`which vim`
export VISUAL="$EDITOR"
export RLWRAP_EDITOR="vim +%L"
which lesspipe.sh > /dev/null && export LESSOPEN="|lesspipe.sh %s"
which lesspipe > /dev/null && export LESSOPEN="|lesspipe %s"

which keychain > /dev/null
if [ $? = 0 ]; then
  eval `keychain --eval --quick --quiet`
else
  if [ -f "$HOME/.keychain/${HOST}-sh" ]; then
    source "$HOME/.keychain/${HOST}-sh"
  fi
fi


path=(
  "$HOME/.bin"
  "$HOME/.local/bin"
  $path
)

if [ -f "$HOME/.cabal" ]; then
  export PATH="$HOME/.cabal/bin:$PATH"
fi

ipad_ua='Mozilla/5.0 (iPad; U; CPU OS 4_3_3 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2 Safari/6533.18.5'
iphone_ua='Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_3_3 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2 Safari/6533.18.5'
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
#setopt sharehistory
#setopt nomatch
unsetopt notify

bindkey -v
bindkey -v "^R" history-incremental-search-backward

autoload -U compinit
fpath=(
  $fpath
  $HOME/.local/zshcomp
  $HOME/.local/zsh-completions/src
)
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
  alias b='brew'
  alias nmblookup='smbutil lookup'
elif [ `uname -s` = 'Linux' ] || [ `uname -o` = 'Cygwin' ]; then
  alias ls="ls --color=auto"
else
  alias ls="ls -G"
fi

alias more='less'

if [ "$TERM" = 'screen' ] || [ "$TERM" = 'xterm' ]; then
  alias mutt='TERM=xterm-256color mutt'
fi

which colordiff &> /dev/null
if [ $? -eq 0  ]; then
  alias diff='colordiff'
fi

alias -g L='| less'
alias -g G='| grep --color=auto -n'
alias -g H='| head'
alias -g SP="| curl -F 'sprunge=<-' http://sprunge.us"
alias turxvt='tabbed -d urxvt -embed; exit'
alias tuxterm='tabbed -d xterm -into; exit'
alias grep='grep --color=auto -n'
which iftop &> /dev/null && alias iftop='iftop -B'
alias hdtemp='echo `netcat localhost 7634`'
alias sysd='systemctl'
alias rd='rdesktop -u administrator -g 1024x768 -x m -r clipboard'
#alias rdd='rdesktop -u administrator -g 1600x1000 -r sound:local -r clipboard -5 -x 0x80 -z -b'
alias rdd='rdesktop -u administrator -g 1600x1000 -r clipboard -5 -x 0x80 -z -b'
alias xf='xfreerdp -u administrator -g 1024x768 -x m -z'
alias xff='xfreerdp -u administrator -g 1600x1000 -x l -z'
alias psg='ps aux | grep '
alias lsmg='lsmod | grep'
alias vacuumsqlite="find . -name '*.sqlite' -exec sqlite3 {} 'VACUUM' \;"
alias tpoff='synclient TouchpadOff=1'
alias tpon='synclient TouchpadOff=0'
#alias emacs='emacs -nw'
alias ht='htop -u $USER'
alias sdo='sudo su ${USER} -c'
alias s='sudo '
alias g='git'
alias v='vim'
alias vd='vimdiff'
alias gd='gvimdiff'
alias wifi='wicd-curses'
alias viscala='rlwrap scala -Xnojline'
alias weathersh='curl http://weather.noaa.gov/pub/data/observations/metar/decoded/ZSSS.TXT'
alias weatherhz='curl http://weather.noaa.gov/pub/data/observations/metar/decoded/ZSHC.TXT'
alias nocaps='setxkbmap -option ctrl:nocaps'
alias truecrypt='truecrypt -t'
alias gbkssh='luit -encoding GBK ssh'
alias ytdl='youtube-dl -t -f18'
alias genpw="cat /dev/urandom| tr -dc '[:graph:]' | fold -w 64 | head -n 10"
which git-annex &> /dev/null alias annex='git-annex'
alias get_cower='wget http://aur.archlinux.org/packages/co/cower/cower.tar.gz'
alias i3lock='i3lock -c 111111'
alias verl='rlwrap erl -oldshell'

if [ 'Darwin' = `uname -s` ]; then
    export HOMEBREW_CASK_OPTS="--appdir=/Applications"
fi

if [ 'hell' = "$HOST" ]; then
  alias mntpriv='sudo truecrypt -t $HOME/.mnt/tcprivate $HOME/.mnt/private'
fi

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
zstyle ':completion:*' substitute 1
zstyle ':completion:*' verbose true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' match-original both

#compdef _pacman {pacman-color,clyde,powerpill,bauerbill}=pacman
#compdef _pacman parsablepackagesize=pacman
#compdef _cp cpf=cp
#compdef _mkdir mkf=mkdir
compctl -g '/etc/rc.d/*(:t)' dstart
compctl -g '/var/run/daemons/*(:t)' dstop drestart
### }}}

#{{{ Functions

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
    echo >2 'Usage: git_new [repo.git]'
    return
  fi

  local repo="$1"
  mkdir -p $repo
  pushd "$repo" > /dev/null
  git init --bare
  popd > /dev/null
}

function git_each_remotes()
{
  local action="$1"
  shift

  for remote in `git remote`; do
    local cmd="git $action $remote"
    if [ -n "$1" ]; then
      cmd="$cmd $@"
    fi

    echo ">>>> Running [${cmd}]"
    eval "$cmd"
  done
}

function upload_one_pic_imgur()
{
  # API Key provided by Alan@imgur.com
  local API_KEY="b3625162d3418ac51a9ee805b1840452"
  local API_URL="http://imgur.com/api/upload.xml"

  local FILE="$1"
  local IMGUR_RESPONSE
  local GREP='/usr/bin/env grep'

  if [ "x${IMGUR_API_KEY}" != "x" ]; then
    API_KEY="$IMGUR_API_KEY"
  fi

  IMGUR_RESPONSE="`curl -F "key=$API_KEY" -F "image=@${FILE}" $API_URL`"

  echo ">>> $FILE"
  echo ">>>" `echo $IMGUR_RESPONSE | $GREP -E -o '<original_image>(.+)</original_image>' | $GREP -E -o 'http://i.imgur.com/[^<]*'`
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
    curl -sL "http://www.google.com/finance/converter?a=$amo&from=$from&to=$i&hl=es" | /usr/bin/env grep 'result' | sed 's/<[^>]*>//g'
  done
}

function mksshafg()
{
  local s;
  test -d ~/.keychain || mkdir ~/.keychain
  s=`ls /tmp/ssh-*/* | head -n1`
  echo "SSH_AUTH_SOCK=$s; export SSH_AUTH_SOCK;" | tee $HOME/.keychain/${HOST}-sh > /dev/null
  source $HOME/.keychain/${HOST}-sh
}

function allkeychain()
{
  for n in `find $HOME/.ssh/. -name '*.pub'`; do
    local k=`basename $n`
    eval `keychain --eval ${k%.pub}`
  done
}


function active_rbenv()
{
  # export RUBY_BUILD_SKIP_MIRROR=1
  # export RUBY_BUILD_CACHE_PATH=$HOME/.rbenv/cache
  # option for `./configure` ruby
  # CONFIGURE_OPTS="--disable-install-rdoc"
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
  rbenv rehash
  rehash
}

function active_pyenv()
{
  # export VIRTUAL_ENV_DISABLE_PROMPT=1
  source "$HOME/.local/opt/pyenv/$1/bin/activate"
}

function create_pyenv_real()
{
  local venv=`which virtualenv`
  if [ -n `which virtualenv2 &> /dev/null` ]; then
    venv=`which virtualenv2`
  fi

  # TODO use setuptools after virtualenv 2.0 release
  $venv --distribute --system-site-packages $@
}

function create_pyenv()
{
  create_pyenv_real "$HOME/.local/opt/pyenv/$1"
}

function redirect_port()
{
  local tar=$1
  local port=$2
  local lport=$3
  if [ -z "$lport" ]; then
    lport=$port
  fi
  socat TCP-LISTEN:$lport,fork TCP:$tar:$port
}

#}}}

