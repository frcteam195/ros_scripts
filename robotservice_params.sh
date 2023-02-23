#!/bin/bash

export ROBOT_JETSON_IP=$(sudo cat "/etc/NetworkManager/system-connections/Wired connection 1.nmconnection" | grep address1 | cut -d= -f2 | cut -d/ -f1)

if [ -z "${ROBOT_JETSON_IP}" ]; then
    echo "Failed to use default wired connection. Attempting second method for older devices..."
    export ROBOT_JETSON_IP=$(sudo cat "/etc/NetworkManager/system-connections/Wired connection 1" | grep address1 | cut -d= -f2 | cut -d/ -f1)
fi