FROM debian:buster

RUN \
 apt-get update \
 && apt-get install -y --no-install-recommends wget gnupg2 ca-certificates iproute2 supervisor \
 && echo 'deb https://deb.sipwise.com/spce/mr9.4.1/ buster main' > /etc/apt/sources.list.d/sipwise.list \
 && echo 'deb-src https://deb.sipwise.com/spce/mr9.4.1/ buster main' >> /etc/apt/sources.list.d/sipwise.list \
 && wget -q -O - https://deb.sipwise.com/spce/keyring/sipwise-keyring-bootstrap.gpg | apt-key add - \
 && apt-get update \
 && apt-get install -y --no-install-recommends ngcp-rtpengine \
 && apt-get install -y --no-install-recommends kamailio kamailio-websocket-modules

#RUN apt-get update \
#  && apt-get -y --quiet --force-yes upgrade curl iproute2 \
#  && apt-get install -y --no-install-recommends ca-certificates gcc g++ make build-essential git iptables-dev libavfilter-dev \
#  libevent-dev libpcap-dev libxmlrpc-core-c3-dev markdown \
#  libjson-glib-dev default-libmysqlclient-dev libhiredis-dev libssl-dev \
#  libcurl4-openssl-dev libavcodec-extra gperf libspandsp-dev libwebsockets-dev\
#  && cd /usr/local/src \
#  && git clone https://github.com/sipwise/rtpengine.git \
#  && cd rtpengine/daemon \
#  && make && make install \
#  && cp /usr/local/src/rtpengine/daemon/rtpengine /usr/local/bin/rtpengine \
#  && rm -Rf /usr/local/src/rtpengine \
#  && apt-get purge -y --quiet --force-yes --auto-remove \
#  ca-certificates gcc g++ make build-essential git markdown \
#  && rm -rf /var/lib/apt/* \
#  && rm -rf /var/lib/dpkg/* \
#  && rm -rf /var/lib/cache/* \
#  && rm -Rf /var/log/* \
#  && rm -Rf /usr/local/src/* \
#  && rm -Rf /var/lib/apt/lists/* 

VOLUME ["/tmp"]

EXPOSE 23400-23500/udp

COPY ./entrypoint.sh /entrypoint.sh
COPY ./config/supervisor-rtpengine.conf /etc/supervisor/conf.d/rtpengine.conf
COPY ./config/supervisor-kamailio.conf /etc/supervisor/conf.d/kamailio.conf
COPY ./config/rtpengine.conf /etc/rtpengine/rtpengine.conf
COPY ./config/kamailio.cfg /etc/kamailio/kamailio.cfg

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf -u root"]
