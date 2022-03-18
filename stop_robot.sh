#!/bin/bash
#docker container kill $(docker ps -q)

ROSLAUNCH_PID=$(ps aux | grep '/[o]pt/ros/melodic/bin/roslaunch' | awk '{print $2}')
pkill rosbag
sudo kill -s SIGINT ${ROSLAUNCH_PID}
