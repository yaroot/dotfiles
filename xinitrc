#!/bin/sh

if [ -f $HOME/.myenvrc ]; then
    source $HOME/.myenvrc
fi

# Set keymap
#setxkbmap -layout de

# Map [CapsLock] to [Ctrl]
( sleep 1s && xmodmap -e 'clear Lock' ) &
( sleep 1s && xmodmap -e 'keycode 66 = Control_L'  ) &
#( sleep 1s && xmodmap -e 'keycode 66 = Escape'  ) &
# Slow the mouse
( sleep 1s && xset m 10/10 ) &
# Sync two X clipboard
#( sleep 2s && autocutsel -fork) &
( sleep 2s && autocutsel -selection PRIMARY -fork ) &
# load X configs
( sleep 3s && xrdb $HOME/.Xdefaults ) &
# xscreensaver, input method, etc.
( sleep 2s && xcompmgr & )
( sleep 5s && xscreensaver -no-splash &)
( sleep 3s && ibus-daemon --xim &)
if [ "`acpi -b`" ]; then
    ( sleep 3s && wicd-client &)
    #( sleep 1s && synclient TouchpadOff=1 &)
fi
( sleep 4s && xbindkeys -f $HOME/.xbindkeysrc & )
#( sleep 2s && urxvtd -q -o -f &)
# java fix
( sleep 1s && wmname LG3D &)

# Set wallpaper
if [ -x ~/.wallpaperrc ]; then
    ( bash ~/.wallpaperrc &)
fi

function launchdwm()
{

    ( sleep 1s && $HOME/.dwmstatus )&

    xsetroot -cursor_name left_ptr &

    # systray
    ( sleep 2s && trayer --expand true --widthtype request --height 8 --transparent true --alpha 255 --edge top --align right & )

    # background color
    #xsetroot -solid midnightblue

    rm -f $HOME/.dwm.log

    # run forever
    while true; do
        $HOME/.dwm > $HOME/.dwm.log 2>&1
    done
}

case $1 in
    xfce*)        exec ck-launch-session startxfce4;;
    wmii)         exec wmii             ;;
    *)            launchdwm             ;;
esac

