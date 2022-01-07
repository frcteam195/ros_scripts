#!/bin/bash

#specify username
#USERNAME=team195

#Get username if user is sudoing
USERNAME=$(who | awk '{print $1}')
echo "Running setup for user ${USERNAME}"

if [[ $EUID -ne 0 ]] || [ "${USERNAME}" = "root" ]; then
   echo "This script must be run with sudo from the user account you plan on using" 
   exit 1
fi

docker pull guitar24t/ck-ros:latest

mkdir /robot
cd /robot
git clone https://github.com/frcteam195/ros_scripts.git
cd /
chown -R $USERNAME:$USERNAME /robot
chmod +x /robot/ros_scripts/*.sh

nmcli con mod "Wired connection 1" ipv4.addresses "10.1.95.5/8" ipv4.gateway "10.0.0.1" ipv4.dns "8.8.8.8,8.8.4.4" ipv4.method "manual" ipv6.method "ignore"

echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" | (sudo su -c 'EDITOR="tee -a" visudo')

#mv /robot/ros_scripts/jetsonclocks.service /etc/systemd/system/
#chown root:root /etc/systemd/system/jetsonclocks.service
#chmod 644 /etc/systemd/system/jetsonclocks.service

mv /robot/ros_scripts/robot_run.service /etc/systemd/system/
chown root:root /etc/systemd/system/robot_run.service
chmod 644 /etc/systemd/system/robot_run.service

systemctl daemon-reload
#systemctl enable jetsonclocks.service
systemctl enable robot_run.service
