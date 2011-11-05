#!/bin/bash -x

suer=""

if [ $UID -ne 0 ] ; then
    echo "You have to be root !"
	if [ "$TERM" = "dumb" ] ; then
		if [ -x "/usr/bin/gksudo" ] ; then
			suer="/usr/bin/gksudo"
		elif [ -x "/usr/bin/gksu" ] ; then
			suer="/usr/bin/gksu"
		fi
	elif [ -x "/usr/bin/sudo" ] ; then
		suer="/usr/bin/sudo"
	else
        suer="/bin/su"
	fi
	$suer "$0"
	exit 0
fi

powerlevel=`cat /sys/class/drm/card0/device/power_profile`

for i in `seq 0 1 4` ; do actives[$i]=FALSE ; done

case "$powerlevel" in
"default")
	actives[0]="TRUE";;
"auto")
	actives[1]="TRUE";;
"high")
	actives[2]="TRUE";;
"mid")
	actives[3]="TRUE";;
"low")
	actives[4]="TRUE";;
*)
	;;
esac

ret=`zenity --list --radiolist --column "Choice" --column "Power Level" --width 100 --height 300 ${actives[0]} "default" ${actives[1]} "auto" ${actives[2]} "high" ${actives[3]} "med" ${actives[4]} "low"`

if [ -n "$ret" ] ; then
	echo $ret > /sys/class/drm/card0/device/power_profile
fi
