#!/bin/sh

if [ "xterm" = "$1" ]; then
  shift
fi

WMCHOICE="dwm"
STANDALONEWM=true

if [ -n "$1" ]; then
  WMCHOICE="$1"
fi
case "$WMCHOICE" in
  xfce*)  STANDALONEWM=false ;;
esac

xset m 16/10 # slow down the mouse
# synclient TouchpadOff=1 # disable clipboard

setxkbmap -option ctrl:nocaps

# load X configs
xrdb $HOME/.Xdefaults &

 ( sleep 10 && xcompmgr &)
 ( sleep 3  && xbindkeys -f $HOME/.xbindkeysrc &)
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

  # ( sleep 15 && ibus-daemon --xim &)
  ( sleep 15 && fcitx &)
  ( sleep 15 && pnmixer &)
  ( sleep 5  && /usr/lib/xfce4/notifyd/xfce4-notifyd &)
  ( test -f /run/wicd/wicd.pid && sleep 3 && wicd-client --tray &)
  ( sleep 30 && dropboxd &)
  ( sleep 30 && xscreensaver -no-splash &)
  ( xsetroot -cursor_name left_ptr &)
fi

if [ -f $HOME/.startuprc ]; then
  # feh --no-fehbg --bg-scale ~/.wallpaper.jpg
  # xsetroot -solid midnightblue # background color
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

launchbspwm()
{
  export EWMHSTATUS_FIFO=/tmp/ewmhstatus.fifo
  while true; do
    bspwm || exit
    sleep 1
  done
}

case $WMCHOICE in
  xfce*)        exec startxfce4 ;;
  bspwm)        launchbspwm  ;;
  awesome)      awesome ;;
  dwm)          launchdwm ;;
esac

