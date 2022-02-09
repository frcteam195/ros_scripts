#!/bin/bash

source /robot/ros_scripts/robotservice_params.sh

cd /robot
umask 0002
docker run --rm \
	-e ROS_IP=${ROBOT_JETSON_IP} \
	-e ROS_MASTER_URI="http://${ROBOT_JETSON_IP}:11311" \
	-v "$(pwd)":/mnt/working \
	--volume="/etc/group:/etc/group:ro" \
	--volume="/etc/gshadow:/etc/gshadow:ro" \
	--volume="/etc/passwd:/etc/passwd:ro" \
	--volume="/etc/shadow:/etc/shadow:ro" \
	--net=host \
	-e HOME=/mnt/working \
	--runtime nvidia \
	--privileged \
	guitar24t/ck-ros:latest \
	/bin/bash -c /mnt/working/ros_scripts/roslaunch_robot.sh

