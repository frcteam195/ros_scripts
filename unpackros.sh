#!/bin/bash
sudo systemctl stop robot_run.service
rm -Rf /robot/*_Robot
tar -mxzf /robot/rosdeploy.tar.gz --directory /robot/
rm -Rf /robot/rosdeploy.tar.gz
sudo sync
sudo systemctl start robot_run.service

