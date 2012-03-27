#!/bin/sh


# Set keymap
#setxkbmap -layout de

xmodmap -pke | tee $HOME/.xmodmap_backup &>/dev/null
xmodmap $HOME/.xmodmaprc

# Slow the mouse
xset m 16/10

# load X configs
xrdb $HOME/.Xdefaults &

 ( sleep 2  && xcompmgr &)
#( sleep 1  && synclient TouchpadOff=1 &)
 ( sleep 4  && xbindkeys -f $HOME/.xbindkeysrc & )
#( sleep 2  && urxvtd -q -o -f &)

# Sync two X clipboard
#( sleep 2s && autocutsel -fork &)
 ( sleep 3  && autocutsel -selection PRIMARY -fork &)

# VirtualBox guest
 ( sleep 5  && VBoxClient-all &)

# java fix
 ( sleep 5  && wmname LG3D &)

if [ -f ~/.startuprc ]; then
    # feh --no-fehbg --bg-scale ~/.wallpaper.jpg
    # xsetroot -solid midnightblue # background color
    (source ~/.startuprc)
fi

wmshared()
{
    ( sleep 30 && xscreensaver -no-splash &)
    ( sleep 15 && ibus-daemon --xim &)
    ( sleep 1  && wicd-client --tray &)
    xsetroot -cursor_name left_ptr &
}

launchwmii()
{
    exec wmii
}

launchdwm()
{
    ( sleep 1 && $HOME/.local/bin/dwmstatus )&

    # systray
    ( sleep 1 && trayer --expand true --widthtype request --height 16 --transparent true --alpha 255 --edge top --align right & )

    # run forever
    while true; do
        $HOME/.local/bin/dwm > $HOME/.dwm.log 2>&1
        sleep 1
    done
}

if [ "xterm" = "$1" ]; then
    shift
fi

case $1 in
    xfce*)        exec ck-launch-session startxfce4 ;;
    wmii)         wmshared; launchwmii              ;;
    *)            wmshared; launchdwm               ;;
esac

