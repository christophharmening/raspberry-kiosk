#!/bin/bash

#############
# Variablen #
#############
username=pi				# username for autologin
url=https://www.google.de		# shown url in format https://www.web.de
pause_time=60				# time in seconds to wait between url refreshs
scan_time=23				# hour when clamav doing a systemscan
clam_log=/var/log/clamav/scan.log	# logfile for clamav virus found
BIN=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd) 	# where i am?


##########
# root ? #
##########
if [ "$EUID" -ne 0 ] ; then echo "Please run as root!"; exit 1; fi

########################
# First upgrade system #
########################
apt-get update && apt-get upgrade -y

####################
# Needed GUI tools #
####################
apt-get install -y openbox lightdm chromium-browser xdotool unclutter

#################
# GUI autologin #
#################
systemctl set-default graphical.target

# Disable konsole autologin
if [ -f ${file_konsole_autologin} ] ; then rm -rf ${file_konsole_autologin} ; fi

# Disable old GUI autologin
sed /etc/lightdm/lightdm.conf -i -e "s/^autologin-user=.*/#autologin-user=/"

# Set new autologin for user
if [ ! -d /etc/lightdm/lightdm.conf.d ]; then mkdir -p /etc/lightdm/lightdm.conf.d ; fi
if [ -f /etc/lightdm/lighdm.conf.d/12-autologin.conf ]; then rm -rf /etc/lightdm/lighdm.conf.d/12-autologin.conf ; fi
sed /etc/lightdm/lightdm.conf -i -e "s/^#autologin-user=/#autologin-user=${username}/"

#########################
# OpenBox configuration #
#########################

# autostart
if [ -d /home/${username}/.config/openbox ]; then mkdir -p /home/${username}/.config/openbox ; fi
cp ${BIN}/template/home/user/.config/openbox/autostart.sh /home/${username}/.config/openbox/autostart.sh
sed -i /home/${username}/.config/openbox/autostart.sh "s/-URL-/${url}/g"
sed -i /home/${username}/.config/openbox/autostart.sh "s/-TIME-/${pause_time}/g"
chmod +x /home/${username}/.config/openbox/autostart.sh

# kontextmenu
cp ${BIN}/template/home/user/.config/openbox/menu.xml /home/${username}/.config/openbox/menu.xml
chmod +x /home/${username}/.config/openbox/menu.xml

# change owner
chown -R ${username}. /home/${username}

###########################
# little system hardening #
###########################

# firewall
# in arbeit ;)

# antivirus
apt-get install clamav -y
# get new virus definitions
#systemctl stop clamav-freshclam ; freshclam
echo "00 ${scan_time} * * * root   clamscan --remove -ir / | grep FOUND >> ${clam_log}" >> /etc/crontab

# automatic updates
apt-get install unattended-upgrades -y
cp ${BIN}/template/etc/apt/apt.conf.d/50unattended-upgrades /etc/apt/apt.conf.d/50unattended-upgrades
chmod 644 /etc/apt/apt.conf.d/50unattended-upgrades

reboot


