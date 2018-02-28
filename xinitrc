#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

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

#creating display status variables
VGA=$(cat /sys/class/drm/card0-VGA-1/status)
HDMI=$(cat /sys/class/drm/card0-HDMI-A-1/status)

#set up display if VGA-1 or HDMI-1 screen is connected,
#otherwise, load auto display settings
if [ $VGA == "connected" ]; then
  xrandr --output eDP-1 --primary --auto --output VGA-1 --left-of eDP-1 --auto --rotate left &
elif [ $HDMI == "connected" ]; then
  xrandr --output eDP-1 --primary --auto --output HDMI-1 --right-of eDP-1 --auto --rotate left &
else
  xrandr --auto &
fi

#set background and terminal color scheme
wal -i "$HOME/pictures/wallpapers/moss.jpg"
(wal -rt)

#lock screen on startup
lock -f Inconsolata-Regular -t "welcome" -- scrot -q 100

#disable screen timeout
xset s off -dpms &

#change cursor appearance
xsetroot -cursor_name left_ptr &

#set danish keybord map
setxkbmap dk &

#start compositor
compton -CGb &

#start window manager
exec bspwm
