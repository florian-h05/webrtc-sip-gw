#!/bin/bash
set -e

#MY_IP=`ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/'`
MY_IP=`hostname -I | awk '{print $1}'`

sed -i -e "s/MY_IP/$MY_IP/g" /etc/rtpengine/rtpengine.conf
sed -i -e "s/FILL_MY_IP/$MY_IP/g" /etc/kamailio/kamailio.cfg

exec $@

