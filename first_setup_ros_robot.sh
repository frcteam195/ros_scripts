#!/bin/bash

#specify username
#USERNAME=team195

if [ ! -f /var/run/resume-ros-setup-after-reboot ]; then

    #Get username if user is sudoing
    USERNAME=$(who | awk 'NR==1{print $1}' )
    echo "Running setup for user ${USERNAME}"

    if [[ $EUID -ne 0 ]] || [ "${USERNAME}" = "root" ]; then
        echo "This script must be run with sudo from the user account you plan on using" 
        exit 1
    fi

    sudo usermod -aG docker $USERNAME
    docker pull guitar24t/ck-ros:latest

    mkdir /robot
    cd /robot
    git clone https://github.com/frcteam195/ros_scripts.git
    cd /
    chown -R $USERNAME:$USERNAME /robot
    chmod +x /robot/ros_scripts/*.sh

    nmcli con mod "Wired connection 1" ipv4.addresses "10.1.95.5/8" ipv4.gateway "10.0.0.1" ipv4.dns "8.8.8.8,8.8.4.4" ipv4.method "manual" ipv6.method "ignore"

    #Disable password entry for sudo
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" | (sudo su -c 'EDITOR="tee -a" visudo')
    #Disable USB Autosuspend
    sed -i '$s/$/ usbcore.autosuspend=-1/'  /boot/extlinux/extlinux.conf

    mv /robot/ros_scripts/robot_run.service /etc/systemd/system/
    chown root:root /etc/systemd/system/robot_run.service
    chmod 644 /etc/systemd/system/robot_run.service

    systemctl daemon-reload
    systemctl enable robot_run.service

    sudo timedatectl set-ntp false
    sudo timedatectl set-timezone America/New_York

    #here, need to modify udev to use rtc0 and reboot
    sudo sed -i 's/ATTR{hctosys}=="1"/ATTR{hctosys}=="0"/g' /usr/lib/udev/rules.d/50-udev-default.rules

    sudo touch /var/run/resume-ros-setup-after-reboot

    sudo sync
    echo "After rebooting, log in again and run the script again to continue. After the second reboot, it is done."
    read -p "Press enter to reboot..."
    sudo reboot
else 

    #set date and time
    read -p 'Enter the date YYYY-MM-DD : ' datevar
    read -p 'Enter the time hh:mm:ss : ' timevar

    sudo timedatectl set-time ${datevar}
    sudo timedatectl set-time ${timevar}

    hwclock -w -f /dev/rtc0
    hwclock -r -f /dev/rtc0

    echo 'hwclock --hctosys' | sudo tee -a /etc/systemd/nv.sh

    #Patch kernel for realsense
    #cd $(dirname $0)
    #git clone https://github.com/IntelRealSense/librealsense
    #cd librealsense
    #chmod +x ./scripts/*
    #./scripts/patch-realsense-ubuntu-L4T.sh

    sudo apt-get update
    sudo apt-get install dkms -y

    git clone https://github.com/lwfinger/rtl8723bu.git
    cd rtl8723bu
    source dkms.conf
    sudo mkdir /usr/src/$PACKAGE_NAME-$PACKAGE_VERSION
    sudo cp -r core hal include os_dep platform dkms.conf Makefile rtl8723b_fw.bin /usr/src/$PACKAGE_NAME-$PACKAGE_VERSION
    sudo dkms add $PACKAGE_NAME/$PACKAGE_VERSION
    sudo dkms autoinstall $PACKAGE_NAME/$PACKAGE_VERSION


    sudo crontab -l | { cat; echo "@reboot /robot/log_cleanup.sh"; } | sudo crontab -


    #Uncomment these to save space on eMMC storage if needed
    #sudo rm -rf /var/lib/apt/lists/*
    #sudo apt-get clean

    sudo systemctl set-default multi-user.target
    sudo rm -Rf /var/run/resume-ros-setup-after-reboot
    sudo sync
    read -p "Completed! Press enter to reboot..."
    sudo reboot
fi