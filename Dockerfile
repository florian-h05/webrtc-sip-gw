FROM debian:buster

RUN \
 apt-get update \
 && apt-get install -y --no-install-recommends wget gnupg2 ca-certificates iproute2 supervisor nano \
 && echo 'deb https://deb.sipwise.com/spce/mr9.4.1/ buster main' > /etc/apt/sources.list.d/sipwise.list \
 && echo 'deb-src https://deb.sipwise.com/spce/mr9.4.1/ buster main' >> /etc/apt/sources.list.d/sipwise.list \
 && wget -q -O - https://deb.sipwise.com/spce/keyring/sipwise-keyring-bootstrap.gpg | apt-key add - \
 && apt-get update \
 && apt-get install -y --no-install-recommends ngcp-rtpengine \
 && apt-get install -y --no-install-recommends kamailio kamailio-websocket-modules kamailio-tls-modules

VOLUME ["/tmp"]

EXPOSE 23400-23500/udp
EXPOSE 8090/tcp
EXPOSE 8091/tcp

COPY ./entrypoint.sh /entrypoint.sh
COPY ./config/supervisor-rtpengine.conf /etc/supervisor/conf.d/rtpengine.conf
COPY ./config/supervisor-kamailio.conf /etc/supervisor/conf.d/kamailio.conf
COPY ./config/rtpengine.conf /etc/rtpengine/rtpengine.conf
COPY ./config/kamailio.cfg /etc/kamailio/kamailio.cfg
COPY ./config/tls.cfg /etc/kamailio/tls.cfg

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf -u root"]
