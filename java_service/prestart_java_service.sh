#!/bin/bash
source /robot/ros_scripts/robotservice_params.sh
/bin/sh -c "until ping -c1 ${ROBOT_JETSON_IP}; do sleep 1; done;"

