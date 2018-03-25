#!/bin/sh

VGA=$(cat /sys/class/drm/card0-VGA-1/status) 
HDMI=$(cat /sys/class/drm/card0-HDMI-A-1/status)

#set up screen if VGA-1 screen is connected
if [ $VGA == "connected" ]; then
  xrandr --output eDP-1 --primary --auto --output VGA-1 --left-of eDP-1 --auto --rotate left
  wal -q -t -i $wallpaper
  bspc monitor VGA-1 -s eDP-1
  bspc monitor eDP-1 -d 1 2 3 4 5 6 7 8
  bspc monitor VGA-1 -d 9 10
fi

#set up screen if HDMI-1 screen is connected
if [ $HDMI == "connected" ]; then
  xrandr --output eDP-1 --primary --auto --output HDMI-1 --left-of eDP-1 --auto --rotate left
  wal -q -t -i $wallpaper
  bspc monitor HDMI-1 -s eDP-1
  bspc monitor eDP-1 -d 1 2 3 4 5 6 7 8
  bspc monitor HDMI-1 -d 9 10
fi

#reloading automatic settings if nothing is connected
if [ $HDMI == "disconnected" ] && [ $VGA == "disconnected" ]; then
  xrandr --output eDP-1 --primary --auto --output HDMI-1 --off --output VGA-1 --off
  wal -q -t -i $wallpaper
  bspc monitor eDP-1 -d 1 2 3 4 5 6 7 8 9 10
fi

