#!/bin/sh

if [ -f $HOME/.myenvrc ]; then
    source $HOME/.myenvrc
fi

# Set keymap
#setxkbmap -layout de

# Map [CapsLock] to [Esc]
( sleep 1s && xmodmap -e 'clear Lock' ) &
( sleep 1s && xmodmap -e 'keycode 66 = Escape'  ) &
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

function other_stuffs()
{
    # Set mouse
    xsetroot -cursor_name left_ptr

    ( sleep 2s && trayer --expand true --widthtype request --height 8 --transparent true --alpha 255 --edge top --align right & )
    #( sleep 2s && trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 5 --height 8 --transparent true --tint 0x000000 ) &

    # background color
    #xsetroot -solid midnightblue
}

function status_text()
{
    while true; do
        sleep 10s
        xsetroot -name "$(acpi -b | cut -d ',' -f2)  $(date +'%a %b %d %Y %H:%M')            "
    done
}

function launchdwm()
{
    other_stuffs
    status_text &

    touch $HOME/.dwm.log

    while true; do
        $HOME/.dwm > $HOME/.dwm.log 2>&1
    done
}

case $1 in
    xfce)         exec ck-launch-session startxfce4;;
    wmii)         exec wmii             ;;
    *)            launchdwm             ;;
esac

