#!/bin/sh

# Source scripts in /etc/X11/xinit/xinitrc.d/
if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

xsetroot -cursor_name left_ptr
#~/.fehbg &
volumeicon &
trayer --edge top --align right --margin 410 --widthtype 300 --height 18 --transparent true --alpha 255 &
wicd-client &
dropboxd &
~/.xinputrc &
xset -b
exec ck-launch-session xmonad
