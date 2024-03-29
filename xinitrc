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

 ( sleep 1  && xbindkeys -f $HOME/.xbindkeysrc &)
#( sleep 1 && autocutsel -fork &) # kinda annoying
 ( sleep 1  && autocutsel -selection PRIMARY -fork &)
 ( sleep 1  && wmname LG3D &) # java fix

( test -f "$HOME/.synergys.conf" && sleep 1 && synergys --debug WARNING -c $HOME/.synergys.conf &)

export XMODIFIERS="@im=fcitx5"
export GTK_IM_MODULE=fcitx5
export QT_IM_MODULE=fcitx5
export INPUT_METHOD=fcitx5
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
  which gnome-keyring-daemon &>/dev/null && eval `gnome-keyring-daemon --start`
  export SSH_AUTH_SOCK

  ( sleep 1  && /usr/lib/xfce4/notifyd/xfce4-notifyd &)
  # ( sleep 1 && ibus-daemon --xim &)
  ( sleep 3 && fcitx5 &)
  # ( sleep 3 && volumeicon &)
  # # ( sleep 1 && cadence &)
  # # ( sleep 1 && qjackctl &)
  ( sleep 5 && pasystray &)
  ( sleep 10 && blueman-applet &)
  # ( sleep 10 && solaar &)
  # ( test -d $HOME/Dropbox && sleep 5 && dropbox &)
  # ( test -d $HOME/ownCloud && sleep 5 && owncloud &)
  ( sleep 5 && xautolock -time 10 -locker 'xsecurelock' &) # i3lock -c 111111
  ( sleep 5 && xss-lock -- xautolock -locknow &)
  # ( sleep 30 && xscreensaver -no-splash &)
  ( sleep 5 && systemctl is-enabled connman_iwd && cmst --minimized &)
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
# setxkbmap -option caps:none,altwin:swap_alt_win
# synclient MinSpeed=2.5 MaxSpeed=2.5 AccelFactor=0
# xbacklight -set 80  # screen brightness
# export GDK_DPI_SCALE=1.5
# export QT_SCALE_FACTOR=1.5

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

  exec i3 -V  |& tee $HOME/.i3/i3.log
  # exec i3 -V > $HOME/.i3/i3.log 2>&1
}

case $WMCHOICE in
  xfce*)        exec startxfce4 ;;
  dwm)          launchdwm ;;
  i3)           launchi3 ;;
esac

