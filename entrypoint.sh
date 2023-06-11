#!/bin/bash
set -e

MY_IP=${MY_IP:=$(hostname -I | awk '{print $1}')}
MY_DOMAIN=${MY_DOMAIN:=$(hostname)}
MY_SIP_DOMAIN=${FILL_SIP_DOMAIN:=fritz.box}

sed -i -e "s/FILL_MY_IP/${MY_IP}/g" /etc/rtpengine/rtpengine.conf
sed -i -e "s/FILL_MY_IP/${MY_IP}/g" /etc/kamailio/kamailio.cfg
sed -i -e "s/FILL_MY_IP/${MY_IP}/g" /healthcheck.sh

sed -i -e "s/FILL_MY_DOMAIN/${MY_DOMAIN}/g" /etc/kamailio/kamailio.cfg
sed -i -e "s/FILL_MY_DOMAIN/${MY_DOMAIN}/g" /etc/kamailio/kamctlrc

sed -i -e "s/FILL_SIP_DOMAIN/${SIP_DOMAIN}/g" /etc/kamailio/kamctlrc

# Allow disabling TLS by setting the TLS_DISABLE env variable to true
if [ "$TLS_DISABLE" == true ]; then
  sed -i -e "s/#!define WITH_TLS/##!define WITH_TLS/" /etc/kamailio/kamailio.cfg
fi

# shellcheck disable=SC2068
exec $@
