#!/bin/bash

# root ?
if [ "$EUID" -ne 0 ] ; then
	echo "Please run as root!"
	exit 1
fi

# Variablen
username=pi
file_konsole_autologin="/etc/systemd/system/getty@tty1.service.d/autologin.conf"


# First upgrade system
apt-get update && apt-egt upgrade -y

# Needed GUI tools
apt-get install -y openbox lightdm chromium-browser xdotool unclutter

# GUI autologin
systemctl set-default graphical.target
if [ -f ${file_konsole_autologin} ] ; then rm -rf ${file_konsole_autologin} ; fi
 sedtc/lightdm/lightdm.conf -i -e "s/^autologin-user=.*/#autologin-user=/"
 sed /etc/lightdm/lightdm.conf -i -e "s/^#autologin-user=/autologin-user=${username}"
 
