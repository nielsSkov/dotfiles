#!/bin/sh

VGA=$(cat /sys/class/drm/card0-VGA-1/status) 
HDMI=$(cat /sys/class/drm/card0-HDMI-A-1/status)
primaryScr=$((xrandr --listactivemonitors |grep + | awk '{ print$2 }') | sed 's/[^a-zA-Z0-9\-]//g') 

#set up screen if VGA-1 screen is connected
if [ $VGA == "connected" ]; then
  xrandr --output $primaryScr --primary --auto --output VGA-1 --left-of $primaryScr --auto --rotate left
  #wal -q -t -i $colorWal -n
  feh --bg-fill $wallpaper1 $wallpaper2
  bspc monitor VGA-1 -s $primaryScr
  bspc monitor eDP-1 -d 1 2 3 4 5 6 7 8
  bspc monitor VGA-1 -d 9 10
  export LEMON_POSX=1038
  pkill lemonbar
  panel &
fi

#set up screen if HDMI-1 screen is connected
if [ $HDMI == "connected" ]; then
  xrandr --output $primaryScr --primary --auto --output HDMI-1 --left-of $primaryScr --auto --rotate left
  #wal -q -t -i $colorWal -n
  feh --bg-fill $wallpaper1 $wallpaper2
  bspc monitor HDMI-1 -s $primaryScr
  bspc monitor $primaryScr -d 1 2 3 4 5 6 7 8
  bspc monitor HDMI-1 -d 9 10
  export LEMON_POSX=1038
  pkill lemonbar
  panel &
fi

#reloading automatic settings if nothing is connected
if [ $HDMI == "disconnected" ] && [ $VGA == "disconnected" ]; then
  xrandr --output $primaryScr --primary --auto --output HDMI-1 --off --output VGA-1 --off
  #wal -q -t -i $colorWal -n
  feh --bg-fill $wallpaper1
  bspc monitor $primaryScr -d 1 2 3 4 5 6 7 8 9 10
  export LEMON_POSX=15
  pkill lemonbar
  panel &
fi

