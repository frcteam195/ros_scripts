#!/bin/bash

export ROS_IP=$(/bin/ip address show dev eth0 | grep inet | cut -dt -f2 | cut -d/ -f1 | awk '{print $1}')

cd /robot
umask 0002
docker run --rm \
	-e USER=$USER \
	-e ROS_IP=$ROS_IP \
	-v "$(pwd)":/mnt/working \
	-v "$(pwd)":"/home/$USER/" \
	--user $UID:$(id -g) \
	--volume="/etc/group:/etc/group:ro" \
	--volume="/etc/gshadow:/etc/gshadow:ro" \
	--volume="/etc/passwd:/etc/passwd:ro" \
	--volume="/etc/shadow:/etc/shadow:ro" \
	--net=host \
	-e HOME=/mnt/working \
	guitar24t/ck-ros:latest \
	/bin/bash -c /mnt/working/ros_scripts/roslaunch_robot.sh

