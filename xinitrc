#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

#[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

#set background and terminal color scheme
export wallpaper1="$HOME/pictures/wallpapers/library1.jpg"
export wallpaper2="$HOME/pictures/wallpapers/library2.jpg"
export colorWal="$HOME/pictures/wallpapers/mistyForrest.jpg"

#include path to panel in path and set up fifo
#export PATH=$PATH:$HOME/syncDrive/dotfiles/panel
export PATH=$PATH:$HOME/dotfiles/panel
export PANEL_FIFO="/tmp/panel-fifo"

#fix matlab
export _JAVA_AWT_WM_NONREPARENTING=1

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
xrandr --output $primaryScr --primary --auto --output HDMI-1 --off --output VGA-1 --off

#set up display if VGA-1 or HDMI-1 screen is connected,
#otherwise, load auto display settings
if [ $VGA == "connected" ]; then
  xrandr --output $primaryScr --primary --auto --output VGA-1 --left-of $primaryScr --auto --rotate left &
  feh --bg-fill $wallpaper1 $wallpaper2
  export LEMON_POSX=1038
elif [ $HDMI == "connected" ]; then
  xrandr --output $primaryScr --primary --auto --output HDMI-1 --left-of $primaryScr --auto --rotate left &
  feh --bg-fill $wallpaper1 $wallpaper2
  export LEMON_POSX=1038
else
  xrandr --output $primaryScr --primary --auto --output HDMI-1 --off --output VGA-1 --off
  feh --bg-fill $wallpaper1
  export LEMON_POSX=15
fi

source ~/.cache/wal/colors-tty.sh
wal -i "$colorWal" -n -q
#wpg -s $wallpaper2 
(cat $HOME/.config/wpg/sequences &)

#lock screen on startup
$HOME/dotfiles/lock.sh --text "welcome"

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
