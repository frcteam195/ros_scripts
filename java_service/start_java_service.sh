#!/bin/bash

source /robot/ros_scripts/robotservice_params.sh

cd /robot/java_service
umask 0002
/usr/bin/java -jar /robot/ros_scripts/java_service/java_nonlinearff_planner.jar

