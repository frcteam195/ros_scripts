#!/bin/bash
#docker container kill $(docker ps -q)

JAVALAUNCH_PID=$(ps aux | grep '/[u]sr/bin/java' | awk '{print $2}')
sudo kill -s SIGINT ${JAVALAUNCH_PID} || true
ROSLAUNCH_PID=$(ps aux | grep '/[o]pt/ros/noetic/bin/roslaunch' | awk '{print $2}')
#sudo pkill -2 rosbag
sudo kill -s SIGINT ${ROSLAUNCH_PID}
