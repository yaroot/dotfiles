#!/bin/sh


# Set keymap
#setxkbmap -layout de

# Map [CapsLock] to [Ctrl]
#xmodmap -e 'clear Lock'
#xmodmap -e 'keycode 66 = Escape'
xmodmap -e 'remove Lock = Caps_Lock'
xmodmap -e 'remove Control = Control_L'
xmodmap -e 'keysym Caps_Lock = Control_L'
# xmodmap -e 'add Lock = Caps_Lock'
xmodmap -e 'add Control = Control_L'

# Slow the mouse
xset m 10/10 &

# load X configs
xrdb $HOME/.Xdefaults &

( sleep 2 && xcompmgr &)
( sleep 30 && xscreensaver -no-splash &)
( sleep 15 ibus-daemon --xim &)
( sleep 1 && wicd-client &)
#( sleep 1 && synclient TouchpadOff=1 &)
( sleep 4 && xbindkeys -f $HOME/.xbindkeysrc & )
#( sleep 2 && urxvtd -q -o -f &)

# Sync two X clipboard
#( sleep 2s && autocutsel -fork &)
( sleep 3 && autocutsel -selection PRIMARY -fork &)

# VirtualBox guest
( sleep 5 && VBoxClient-all &)

# java fix
( sleep 5 && wmname LG3D &)

# Set wallpaper
if [ -x ~/.wallpaperrc ]; then
    ( ~/.wallpaperrc &)
    # feh --no-fehbg --bg-scale ~/.wallpaper.jpg
fi

if [ -x ~/.startuprc ]; then
    ( ~/.startuprc &)
fi

function launchdwm()
{

    ( sleep 1 && $HOME/.dwmstatus )&

    xsetroot -cursor_name left_ptr &

    # systray
    ( sleep 1 && trayer --expand true --widthtype request --height 8 --transparent true --alpha 255 --edge top --align right & )

    # background color
    #xsetroot -solid midnightblue

    rm -f $HOME/.dwm.log

    # run forever
    while true; do
        $HOME/.dwm > $HOME/.dwm.log 2>&1
        sleep 1
    done
}

case $1 in
    xfce*)        exec ck-launch-session startxfce4;;
    wmii)         exec wmii             ;;
    *)            launchdwm             ;;
esac

