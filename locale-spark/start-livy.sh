#!/bin/bash

#Start livy
/bin/bash ${LIVY_HOME}/bin/livy-server start & tail -f /dev/null #stay live as live-server exits
 