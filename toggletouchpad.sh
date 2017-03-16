#!/bin/bash
#yo="hey"
#echo $yo
#$touchpadStatus = 
status=$(xinput list-props 'ETPS/2 Elantech Touchpad' |grep "Off (288): *" | sed -s 's/.*\:\(.*\).*/\1/')

if [ $status == 0 ]
then
	xinput --set-prop 12 288 2
elif [ $status == 2 ]
then
	xinput --set-prop 12 288 1
elif [ $status == 1 ]
then
	xinput --set-prop 12 288 0
fi
