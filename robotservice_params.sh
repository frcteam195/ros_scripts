#!/bin/bash

export ROBOT_JETSON_IP=$(sudo cat "/etc/NetworkManager/system-connections/Wired connection 1" | grep address1 | cut -d= -f2 | cut -d/ -f1)

