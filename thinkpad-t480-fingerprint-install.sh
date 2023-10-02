#!/bin/bash

echo "Installing drivers for using the fingerprint scanner on Thinkpad T480:"

echo "Your device:"

lsusb | grep -i fingerprint

paru -S open-fprintd fprintd-clients python-validity

sudo systemctl stop python3-validity

sudo validity-sensors-firmware

sudo python3 /usr/share/python-validity/playground/factory-reset.py

sudo systemctl enable --now python3-validity

# Run fprintd

fprintd-enroll

# Prompt for password for enrolling (currently, perhaps forever, not working)
echo "Trying to make it secure by adding Polkit rule"
sudo cp "$(pwd)/fprint-polkit.rules" /etc/polkit-1/rules.d/50-net.reactivated.fprint.device.enroll.rules

# Add it as a possible validation
echo "Do the following steps for authentication configuration. Currently there is a major security issue and it should NOT be done, but these are the next steps:"

echo "Add the following line to the top (but below shebang) of the following files:
auth    sufficient  pam_fprintd.so
/etc/pam.d/{system-local-login,login,su,sudo,lightdm, xfce4-screensaver}"

