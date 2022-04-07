#!/bin/bash
BASE_PATH=$(find /mnt/working/*_Robot -maxdepth 0 -type d)
source ${BASE_PATH}/catkin_ws/devel/setup.bash
LAUNCH_FILE="${BASE_PATH}/launch/prod.launch"
umask 0002
/usr/bin/java -jar /mnt/working/ros_scripts/java_service/java_nonlinearff_planner.jar &
#rosbag record -a -o /mnt/working/ &
roslaunch "${LAUNCH_FILE}"
