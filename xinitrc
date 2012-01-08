#!/bin/sh


# Set keymap
#setxkbmap -layout de

# Map [CapsLock] to [Ctrl]
xmodmap -e 'clear Lock' &
xmodmap -e 'keycode 66 = Control_L' &
# xmodmap -e 'keycode 66 = Escape' &

# Slow the mouse
xset m 10/10 &

# load X configs
xrdb $HOME/.Xdefaults &


( sleep 2s && xcompmgr &)
( sleep 30s && xscreensaver -no-splash &)
( sleep 15s ibus-daemon --xim &)
( sleep 1s && wicd-client &)
#( sleep 1s && synclient TouchpadOff=1 &)
( sleep 4s && xbindkeys -f $HOME/.xbindkeysrc & )
#( sleep 2s && urxvtd -q -o -f &)

# Sync two X clipboard
#( sleep 2s && autocutsel -fork &)
( sleep 3s && autocutsel -selection PRIMARY -fork &)


# java fix
( sleep 5s && wmname LG3D &)

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

    ( sleep 1s && $HOME/.dwmstatus )&

    xsetroot -cursor_name left_ptr &

    # systray
    ( sleep 1s && trayer --expand true --widthtype request --height 8 --transparent true --alpha 255 --edge top --align right & )

    # background color
    #xsetroot -solid midnightblue

    rm -f $HOME/.dwm.log

    # run forever
    while true; do
        $HOME/.dwm > $HOME/.dwm.log 2>&1
        sleep 1s
    done
}

case $1 in
    xfce*)        exec ck-launch-session startxfce4;;
    wmii)         exec wmii             ;;
    *)            launchdwm             ;;
esac

