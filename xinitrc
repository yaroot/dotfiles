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

# load X configs
test -f $HOME/.Xdefaults && xrdb $HOME/.Xdefaults
test -f $HOME/.Xdefaults.local && xrdb -merge $HOME/.Xdefaults.local

 ( sleep 3  && xcompmgr &)
 ( sleep 1  && xbindkeys -f $HOME/.xbindkeysrc &)
#( sleep 1 && autocutsel -fork &) # kinda annoying
 ( sleep 1  && autocutsel -selection PRIMARY -fork &)
 ( sleep 1  && VBoxClient-all &)
 ( sleep 1  && wmname LG3D &) # java fix
#( sleep 3  && urxvtd -q -o -f &) # use tmux/screen

( test -f "$HOME/.synergys.conf" && sleep 1 && synergys --debug WARNING -c $HOME/.synergys.conf &)

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

  ( sleep 1  && /usr/lib/xfce4/notifyd/xfce4-notifyd &)
  # ( sleep 1 && ibus-daemon --xim &)
  ( sleep 1 && fcitx &)
  ( sleep 1 && volumeicon &)
  # ( test -d $HOME/Dropbox && sleep 5 && dropbox &)
  # ( test -d $HOME/ownCloud && sleep 5 && owncloud &)
  ( sleep 1 && xautolock -time 10 -locker 'i3lock -c 111111' &)
  # ( sleep 30 && xscreensaver -no-splash &)
  ( xsetroot -cursor_name left_ptr &)
fi


# mouse accel
# xset m 2/4 1
# xset m 0 0
# synclient TouchpadOff=1 # disable clipboard
# feh --no-fehbg --bg-scale ~/.wallpaper.jpg
# feh --no-fehbg --bg-center ~/.wallpaper.jpg
# xsetroot -solid midnightblue # background color
# setxkbmap -option ctrl:nocaps,altwin:swap_alt_win
# synclient MinSpeed=2.5 MaxSpeed=2.5 AccelFactor=0
# xbacklight -set 80  # screen brightness

if [ -f $HOME/.startuprc ]; then
  (source ~/.startuprc "$WMCHOICE" "$STANDALONE")
fi

launchdwm()
{
  ( sleep 1 && $HOME/.local/bin/dwmstatus &)

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

