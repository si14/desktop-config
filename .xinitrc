# it is for openbox
xrdb -merge ~/.Xresources &

# shoose session
DEFAULT_SESSION=xmonad

case $1 in
openbox-session)
	exec ck-launch-session dbus-launch openbox-session
	;;
*)
	xsetroot -cursor_name left_ptr
	eval `cat ~\.fehbg` &
	volumeicon &
	trayer --edge top --align right --margin 410 --widthtype 300 --height 18 --transparent true --alpha 255 &
	wicd-client &
	dropboxd &
	exec ck-launch-session xmonad
	;;
esac
