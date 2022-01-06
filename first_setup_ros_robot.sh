#!/bin/bash

USERNAME=team195

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

docker pull guitar24t/ck-ros:latest

mkdir /robot
cd /robot
git clone git@github.com:frcteam195/ros_scripts.git
cd /
chown -R $USERNAME:$USERNAME /robot
chmod +x /robot/ros_scripts/*.sh

echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" | (sudo su -c 'EDITOR="tee -a" visudo')

mv /robot/ros_scripts/jetsonclocks.service /etc/systemd/system/
chown root:root /etc/systemd/system/jetsonclocks.service
chmod 644 /etc/systemd/system/jetsonclocks.service

mv /robot/ros_scripts/robot_run.service /etc/systemd/system/
chown root:root /etc/systemd/system/robot_run.service
chmod 644 /etc/systemd/system/robot_run.service

systemctl daemon-reload
systemctl enable jetsonclocks.service
systemctl enable robot_run.service
