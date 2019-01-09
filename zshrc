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
which lesspipe.sh &> /dev/null && export LESSOPEN="|lesspipe.sh %s"
which lesspipe &> /dev/null && export LESSOPEN="|lesspipe %s"

which keychain &> /dev/null
if [ $? = 0 ]; then
  # skip gpg unless explicitly required to load
  if [ -f "$HOME/.gnupg/_keychain" ]; then
    eval `keychain --eval --quick --quiet`
  else
    eval `keychain --eval --quick --quiet --agents ssh`
  fi
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

ipad_ua='Mozilla/5.0 (iPad; CPU OS 7_0_4 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11B554a Safari/9537.53'
iphone_ua='Mozilla/5.0 (iPhone; CPU iPhone OS 7_0_4 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11B554a Safari/9537.53'
firefox_ua='Mozilla/5.0 (Windows NT 6.1; WOW64; rv:26.0) Gecko/20100101 Firefox/26.0'
chrome_ua='Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/536.11 (KHTML, like Gecko) Chrome/20.0.1132.42'
chromium_ua='Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36'
chrome_mac_ua='Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.32 Safari/537.36'

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
setopt histignorespace
unsetopt notify

bindkey -v
bindkey -v "^R" history-incremental-search-backward

autoload -U compinit
fpath=(
  $fpath
  $HOME/.local/zshcomp
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
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

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
alias grep='grep --color=auto -n'
which iftop &> /dev/null && alias iftop='iftop -B'
alias hdtemp='echo `netcat localhost 7634`'
alias sysd='systemctl'
alias psg='ps aux | grep '
alias lsmg='lsmod | grep'
alias vacuumsqlite="find . -name '*.sqlite' -exec sqlite3 {} 'VACUUM' \;"
alias tpoff='synclient TouchpadOff=1'
alias tpon='synclient TouchpadOff=0'
#alias emacs='emacs -nw'
alias ht='htop -u $USER'
alias sdo='sudo su ${USER} -c'
alias s='sudo '
alias fucking='sudo '
alias g='git'
alias v='vim'
alias vd='vimdiff'
alias gd='gvimdiff'
alias wifi='wicd-curses'
alias gbkssh='luit -encoding GBK ssh'
alias ytdl='youtube-dl -f18'
alias infoq='infoqscraper presentation download --type h264_overlay'
alias genpw="cat /dev/urandom| tr -dc '[:graph:]' | fold -w 64 | head -n 10"
alias get_cower='wget https://aur.archlinux.org/cgit/aur.git/snapshot/cower.tar.gz'
alias verl='rlwrap erl -oldshell'
alias urldecode='python2 -c "for l in __import__(\"sys\").stdin.readlines(): print __import__(\"urllib\").unquote_plus(l).strip()"'
alias urlencode='python2 -c "for l in __import__(\"sys\").stdin.readlines(): print __import__(\"urllib\").quote_plus(l).strip()"'
alias htmlescape='python3 -c "for l in __import__(\"sys\").stdin.readlines(): print(__import__(\"html\").escape(l).strip())"'
alias htmlunescape='python3 -c "for l in __import__(\"sys\").stdin.readlines(): print(__import__(\"html\").unescape(l).strip())"'
alias jad='java -cp $HOME/.local/opt/idea-IC/plugins/java-decompiler/lib/java-decompiler.jar org.jetbrains.java.decompiler.main.decompiler.ConsoleDecompiler'
alias idea='$HOME/.local/opt/idea-IC/bin/idea.sh'
alias ideau='$HOME/.local/opt/idea-IU/bin/idea.sh'
alias clion='$HOME/.local/opt/clion/bin/clion.sh'
alias androidstudio='QT_SCREEN_SCALE_FACTORS=1 QT_SCALE_FACTOR=1 $HOME/.local/opt/android-studio/bin/studio.sh'
alias goland='$HOME/.local/opt/goland/bin/goland.sh'
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
#alias alsafox='apulse firefox'
alias ipython='ipython --TerminalInteractiveShell.editing_mode=vi'
alias ipython2='ipython2 --TerminalInteractiveShell.editing_mode=vi'

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
#compctl -g '/etc/rc.d/*(:t)' dstart
#compctl -g '/var/run/daemons/*(:t)' dstop drestart
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

function git_cb()
{
  local b=`git symbolic-ref HEAD`
  echo ${b#refs/heads/}
}

function git_update_bare()
{
  git fetch origin '+refs/heads/*:refs/heads/*' --prune
}

function upload_one_pic_imgur()
{
  # API Key provided by Alan@imgur.com
  local API_KEY="b3625162d3418ac51a9ee805b1840452"
  local API_URL="http://imgur.com/api/upload.xml"

  local FILE="$1"
  local IMGUR_RESPONSE
  local GREP='/usr/bin/grep'

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

  # or use yahoo's http://finance.yahoo.com/currency-converter/
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
  #for n in `find $HOME/.ssh/. -name '*.pub'`; do
  for n in `ls $HOME/.ssh/*.pub`; do
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

# git://github.com/ekalinin/nodeenv.git
# create env: nodeenv -j4 -n $version $env_path
function active_nodeenv()
{
  local ver=$1
  local script="$HOME/.local/opt/nodejs/$ver/bin/activate"
  if [ -f "$script" ]; then
    source "$script"
  else
    echo "[error] unable to active env <$env>"
  fi
}

function active_pyenv()
{
  # export VIRTUAL_ENV_DISABLE_PROMPT=1
  local ver=$1
  local script="$HOME/.local/opt/pyenv/$ver/bin/activate"
  if [ -f "$script" ]; then
    source "$script"
  else
    echo "[error] unable to active env <$ver>"
  fi
}

function active_opam()
{
  source $HOME/.opam_zshrc
}

function active_conda()
{
  export PATH="$HOME/.local/opt/miniconda3/bin:$PATH"
  export PS1="(conda) $PS1"
}

function create_pyenv()
{
  local p=$1
  shift
  virtualenv3 "$HOME/.local/opt/pyenv/$p" $@
}

function create_pyenv2()
{
  local p=$1
  shift
  virtualenv2 "$HOME/.local/opt/pyenv/$p" $@
}

function active_asdf()
{
  source $HOME/.asdf/asdf.sh
  source $HOME/.asdf/completions/asdf.bash
}

function redirect_port()
{
  local tar=$1
  local port=$2
  local lport=$3
  if [ -z "$lport" ]; then
    lport=$port
  fi
  socat TCP-LISTEN:$lport,fork,reuseaddr TCP:$tar:$port
}

function set_proxy_var()
{
  local port="$1"
  if [ -n "$port" ]; then
    export http_proxy="http://127.0.0.1:$port"
    export https_proxy="http://127.0.0.1:$port"
  else
    echo "[usage] set_http_proxy <port>"
  fi
}

function run_jvm_proxy_props()
{
  local port="$1"
  shift
  _JAVA_OPTIONS="-Dhttp.proxyHost=127.0.0.1 -Dhttp.proxyPort=$port" $@
}

function rpas()
{
  local n="$1"
  if [ -z "$n" ]; then
    n=16
  fi
  tr -cd '[:alnum:]' < /dev/urandom | fold -w$n | head -n1
}

function chromium_proxy()
{
  # OPTIONS
  # -p <port>       REQUIRED
  # -h <host>
  # -s              socks5 (default http)
  # -c              google-chrome-beta
  # -u              user-data-dir (~/.local/google-chrome-<alt>)
  # -C <prog>       run <prog>
  local mth="http"
  # test "$2" = 's' && mth='socks5'
  local prog='chromium'
  local port=''
  local addr='127.0.0.1'
  local userdataargs=''

  while getopts "h:p:abcC:su:" opt; do
    case $opt in
      h)
        addr=$OPTARG;;
      p)
        port=$OPTARG;;
      a)
        prog='google-chrome-unstable';;
      b)
        prog='google-chrome-stable';;
      c)
        prog='google-chrome-beta';;
      C)
        prog=$OPTARG;;
      s)
        mth='socks5';;
      u)
        userdataargs="--user-data-dir=$HOME/.local/google-chrome-$OPTARG";;
    esac
  done


  local proxy_args=''
  if [ -n "$port" ]; then
    proxy_args="--proxy-server=$mth://$addr:$port"
  fi
  echo "=== Starting $prog with args [$proxy_args $userdataargs]"
  $prog "$proxy_args" "$userdataargs"
}

function man()
{
  env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;246m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}

function slow_down()
{
  while read x; do echo "$x"; sleep 0.5; done
}


function weather() {
  curl https://wttr.in/$@
}

#}}}

