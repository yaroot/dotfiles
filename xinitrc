#!/bin/sh

if [ "xterm" = "$1" ]; then
    shift
fi
SESSION="dwm"
if [ ! -z "$1" ]; then
    SESSION="$1"
fi
STANDALONE="yes"
case "$SESSION" in
    xfce*) STANDALONE="no" ;;
esac

# Set keymap
# setxkbmap -layout de
xmodmap -pke | tee $HOME/.xmodmap_backup &>/dev/null
xmodmap $HOME/.xmodmaprc

xset m 16/10 # slow the mouse down
# synclient TouchpadOff=1 # disable clipboard

# load X configs
xrdb $HOME/.Xdefaults &

 ( sleep 2  && xcompmgr &)
 ( sleep 4  && xbindkeys -f $HOME/.xbindkeysrc & )
#( sleep 2s && autocutsel -fork &)
 ( sleep 3  && autocutsel -selection PRIMARY -fork &)
 ( sleep 5  && VBoxClient-all &)
 ( sleep 5  && wmname LG3D &) # java fix 
#( sleep 2  && urxvtd -q -o -f &)

if [ "yes" = "$STANDALONE" ]; then
    ( sleep 30 && xscreensaver -no-splash &)
    ( sleep 15 && ibus-daemon --xim &)
    ( sleep 3  && /usr/lib/xfce4/notifyd/xfce4-notifyd &)
    ( sleep 1  && wicd-client --tray &)
    ( sleep 30 && dropboxd &)
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
        $HOME/.local/bin/dwm > $HOME/.dwm.log 2>&1
        sleep 1
    done
}

case $SESSION in
    xfce*)        exec ck-launch-session startxfce4 ;;
    wmii)         exec wmii ;;
    dwm)            launchdwm ;;
esac

