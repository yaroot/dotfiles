#!/usr/bin/env sh

if [ "xterm" = "$1" ]; then
  shift
fi

#WMCHOICE="dwm"
WMCHOICE="i3"
STANDALONEWM=true

if [ -n "$1" ]; then
  WMCHOICE="$1"
fi
case "$WMCHOICE" in
  xfce*)  STANDALONEWM=false ;;
esac


setxkbmap -option ctrl:nocaps

# load X configs
test -f $HOME/.Xdefaults && xrdb $HOME/.Xdefaults
test -f $HOME/.Xdefaults.local && xrdb -merge $HOME/.Xdefaults.local

 ( sleep 10 && xcompmgr &)
#( sleep 3  && xbindkeys -f $HOME/.xbindkeysrc &)
#( sleep 5 && autocutsel -fork &) # kinda annoying
 ( sleep 5  && autocutsel -selection PRIMARY -fork &)
 ( sleep 5  && VBoxClient-all &)
 ( sleep 3  && wmname LG3D &) # java fix 
#( sleep 3  && urxvtd -q -o -f &) # use tmux/screen

( test -f "$HOME/.synergys.conf" && sleep 10 && synergys -c $HOME/.synergys.conf &)

export XMODIFIERS="@im=fcitx"
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
# fcitx-{gtk2,gtk3,qt}
#export GTK_IM_MODULE=xim
#export QT_IM_MODULE=xim

export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

if $STANDALONEWM; then
  # source scripts in xinitrc.d
  if [ -d "/etc/X11/xinit/xinitrc.d" ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
      [ -x "$f" ] && . "$f"
    done
    unset f
  fi

  numlockx on

  ( sleep 5  && /usr/lib/xfce4/notifyd/xfce4-notifyd &)
  # ( sleep 15 && ibus-daemon --xim &)
  ( sleep 15 && fcitx &)
  ( sleep 15 && volumeicon &)
  ( systemctl is-enabled wicd.service &> /dev/null && sleep 3 && wicd-client --tray &)
  ( test -d $HOME/Dropbox && sleep 30 && dropboxd &)
  ( sleep 15 && xautolock -time 10 -locker 'i3lock -c 111111' &)
  # ( sleep 30 && xscreensaver -no-splash &)
  ( xsetroot -cursor_name left_ptr &)
fi

xset m 16/10 1 # mouse default setting
# synclient TouchpadOff=1 # disable clipboard
# feh --no-fehbg --bg-scale ~/.wallpaper.jpg
# xsetroot -solid midnightblue # background color
if [ -f $HOME/.startuprc ]; then
  (source ~/.startuprc "$WMCHOICE" "$STANDALONE")
fi

launchdwm()
{
  ( sleep 5 && $HOME/.local/bin/dwmstatus &)

  while true; do
    # relaunch trayer
    killall trayer
    ( trayer `cat ~/.trayerrc` &)

    # `kill dwm` means logout
    $HOME/.local/bin/dwm || exit

    # wait a sec
    sleep 1
  done
}

launchi3()
{
  mkdir $HOME/.i3

  if [ -f $HOME/.i3/i3.log ]; then
    mv $HOME/.i3/i3.log{,.1}
  fi

  rm $HOME/.i3/config
  cat $HOME/.dotfiles/i3config $HOME/.i3/config.local > $HOME/.i3/config

  exec i3 -V > $HOME/.i3/i3.log 2>&1
}

case $WMCHOICE in
  xfce*)        exec startxfce4 ;;
  dwm)          launchdwm ;;
  i3)           launchi3 ;;
esac

