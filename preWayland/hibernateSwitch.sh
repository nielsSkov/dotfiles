#!/bin/sh

# first follow instructions in: readme/README.hibernate

# place (or link) me in /lib/systemd/system-sleep/

# this script runs pre and post hibernation
#
# pre hibernation it changes grub's timeout to 0 s
# post hibernation it changes grub's timeout to 5 s
#
# this ensures that no other OS is booted when this one is hibernated,
# while also alowing to choose OS in grub at normal boot

grubOffTimeout=0
grubOnTimeout=5

if [ "$2" = hibernate ]; then

	case "$1" in
		pre)
			cat /boot/grub/grub.cfg | sed 's/timeout='$grubOnTimeout'/timeout='$grubOffTimeout'/g' > /boot/grub/grub.cfg~
			mv /boot/grub/grub.cfg~ /boot/grub/grub.cfg
		;;
		post)
			cat /boot/grub/grub.cfg | sed 's/timeout='$grubOffTimeout'/timeout='$grubOnTimeout'/g' > /boot/grub/grub.cfg~
			mv /boot/grub/grub.cfg~ /boot/grub/grub.cfg
		;;
	esac
fi
