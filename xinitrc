#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

#set background and terminal color scheme
export wallpaper="$HOME/pictures/wallpapers/test2.png"

# merge in defaults and keymaps
if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi
if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi
if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi
if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

#set wallpaper
feh --bg-fill $wallpaper

#touchpad settings
xinput set-prop "ASUE140D:00 04F3:31B9 Touchpad" "libinput Tapping Enabled" 1
xinput set-prop "ASUE140D:00 04F3:31B9 Touchpad" "libinput Accel Speed" 0.7

#lock screen on startup
$HOME/dotfiles/lock.sh --text "welcome"

#disable screen timeout
xset s off -dpms &

#change cursor appearance
xsetroot -cursor_name left_ptr &

#set danish keyboard map
setxkbmap dk

#start compositor
picom -b &

#start key map for window manager
sxhkd &

#start window manager
bspwm -c $HOME/.config/bspwm/bspwmrc
