
# X11 Forwarding

Start X server on tty 12
    X :12.0 vt12 &

Open ssh session and start X forwarding
    xterm -display :12.0 -e ssh -X -C login@host &

# Some utils to ease the life

* duff
* bwm-ng, iftraf, ethstatus
* csshX, pdsh, ClusterSSH, mussh

