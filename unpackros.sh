#!/bin/bash
sudo systemctl stop robot_run.service
rm -Rf /robot/*_Robot
tar -xzf /robot/rosdeploy.tar.gz --directory /robot/
rm -Rf /robot/rosdeploy.tar.gz
sudo systemctl start robot_run.service

