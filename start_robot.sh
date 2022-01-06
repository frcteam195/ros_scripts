#!/bin/bash

cd /robot
umask 0002
docker run --rm \
	-e USER=$USER \
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

