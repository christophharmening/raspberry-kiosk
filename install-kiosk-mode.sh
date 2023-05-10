#!/bin/bash



#############
# Variablen #
#############
username=pi			# username for autologin
url=https://www.google.de	# shown url in format https://www.web.de
pause_time=60			# time to wait between url refreshs

# root ?
if [ "$EUID" -ne 0 ] ; then
	echo "Please run as root!"
	exit 1
fi

########################
# First upgrade system #
########################
apt-get update && apt-egt upgrade -y

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
sed /etc/lightdm/lightdm.conf -i -e "s/^#autologin-user=/#autologin-user=pi/"

#########################
# OpenBox configuration #
#########################

# autostart
if [ -d /home/${user}/.config/openbox ]; then mkdir -p /home/${user}/.config/openbox ; fi
#printf "#!/bin/bash \n\nxset s noblank \nxset s off \nxset -dpms \nunclutter &\n chromium --noerrdialogs --disable-infobars --kiosk ${url} & \nwhile true; do \n sleep ${pause_time} \n xdotool key F5 \ndone" > /home/${user}/.config/openbox/autostart.sh

chmod +x /home/${user}/.config/openbox/autostart.sh



