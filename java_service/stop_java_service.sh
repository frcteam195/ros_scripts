#!/bin/bash

JAVALAUNCH_PID=$(ps aux | grep '/[u]sr/bin/java' | awk '{print $2}')
sudo kill -s SIGINT ${JAVALAUNCH_PID}
