#!/bin/sh

# dunno what this shit is
# ignore it
if [ "xterm" = "$1" ]; then
  shift
fi

SESSION="dwm"
STANDALONE="yes"

if [ ! -z "$1" ]; then
  SESSION="$1"
fi
case "$SESSION" in
  xfce*) STANDALONE="no" ;;
esac


# fix lang vars
if [ "x${LANGUAGE}" = "x" ]; then
  export LANGUAGE="$LANG"
fi
if [ "x${LC_ALL}" = "x" ]; then
  export LC_ALL="$LANG"
fi

# Set keymap
# setxkbmap -layout de
xmodmap -pke | tee $HOME/.xmodmap_backup &>/dev/null
if [ -f "$HOME/.xmodmaprc" ]; then
  xmodmap $HOME/.xmodmaprc
fi

xset m 16/10 # slow the mouse down
# synclient TouchpadOff=1 # disable clipboard

# load X configs
xrdb $HOME/.Xdefaults &

 ( sleep 2  && xcompmgr &)
 ( sleep 4  && xbindkeys -f $HOME/.xbindkeysrc & )
#( sleep 2s && autocutsel -fork &) # kinda annoying
 ( sleep 3  && autocutsel -selection PRIMARY -fork &)
 ( sleep 5  && VBoxClient-all &)
 ( sleep 5  && wmname LG3D &) # java fix 
#( sleep 2  && urxvtd -q -o -f &) # use tmux/screen

export XMODIFIERS="@im=fcitx"
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
# fcitx-{gtk2,gtk3,qt}
#export GTK_IM_MODULE=xim
#export QT_IM_MODULE=xim

export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

if [ "yes" = "$STANDALONE" ]; then
  eval `dbus-launch --sh-syntax --exit-with-session`

  #( sleep 15 && ibus-daemon --xim &)
  ( sleep 15 && fcitx &)
  ( sleep 15 && pnmixer &)
  ( sleep 3  && /usr/lib/xfce4/notifyd/xfce4-notifyd &)
  ( sleep 1  && wicd-client --tray &)
  ( sleep 30 && dropboxd &)
  ( sleep 30 && xscreensaver -no-splash &)
  ( xsetroot -cursor_name left_ptr &)
fi

if [ -f ~/.startuprc ]; then
  # feh --no-fehbg --bg-scale ~/.wallpaper.jpg
  # xsetroot -solid midnightblue # background color
  (source ~/.startuprc "$SESSION" "$STANDALONE")
fi

launchdwm()
{
  ( sleep 3 && $HOME/.local/bin/dwmstatus )&
  ( sleep 3 && trayer --expand true --widthtype request --height 16 --transparent true --alpha 255 --edge top --align right & )

  while true; do
    $HOME/.local/bin/dwm #> $HOME/.dwm.log 2>&1
    sleep 1
  done
}

case $SESSION in
  xfce*)        exec ck-launch-session startxfce4 ;;
  wmii)         exec wmii ;;
  dwm)          launchdwm ;;
esac

