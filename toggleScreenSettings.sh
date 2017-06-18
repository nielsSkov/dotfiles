#!/usr/bin/env bash

eDPstatus=$(xrandr |grep -oE "^eDP-1 \w*" | cut -d" " -f2)

HDMIstatus=$(xrandr |grep -oE "^HDMI-1 \w*" | cut -d" " -f2)

VGAstatus=$(xrandr |grep -oE "^VGA-1 \w*" | cut -d" " -f2)

DPstatus=$(xrandr |grep -oE "^DP-1 \w*" | cut -d" " -f2)

if [ $HDMIstatus == 'connected' ]
then
	echo $eDPstatus
else
	echo 'isNotConnected'
fi

#echo $HDMIstatus
#echo $VGAstatus
#echo $DPstatus

