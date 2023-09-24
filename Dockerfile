FROM debian:12-slim

# Basic build-time metadata as defined at http://label-schema.org
LABEL org.label-schema.docker.dockerfile="/Dockerfile" \
  org.label-schema.license="MIT" \
  org.label-schema.name="WebRTC SIP Gateway" \
  org.label-schema.description="A WebRTC-SIP gateway for Fritzbox based on Kamailio and rtpengine" \
  org.label-schema.url="https://github.com/florian-h05/webrtc-sip-gw" \
  org.label-schema.vcs-type="Git" \
  org.label-schema.vcs-url="https://github.com/florian-h05/webrtc-sip-gw.git" \
  maintainer="Florian Hotze <florianh_dev@icloud.com>"

# Install requirements
RUN \
  apt-get update \
  && apt-get install -y --no-install-recommends supervisor nano

# Install Kamailio and rtpengine
RUN \
  apt-get update \
  && apt-get install -y --no-install-recommends rtpengine \
  && apt-get install -y --no-install-recommends kamailio kamailio-websocket-modules kamailio-tls-modules kamailio-presence-modules

# Do not persist /tmp in a volume to allow clearing it by restarting the container
# VOLUME ["/tmp"]

# Expose rtpengine UDP ports
EXPOSE 23400-23500/udp
# Expose Kamailio TCP ports for unsecured and secured SIP over WebSocket
EXPOSE 8090 4443

# Set healthcheck
HEALTHCHECK --interval=30s --timeout=5s --retries=3 CMD bash /healthcheck.sh

COPY ./entrypoint.sh /entrypoint.sh
COPY ./healthcheck.sh /healthcheck.sh
# Copy configuration
COPY ./config/supervisor-rtpengine.conf /etc/supervisor/conf.d/rtpengine.conf
COPY ./config/supervisor-kamailio.conf /etc/supervisor/conf.d/kamailio.conf
COPY ./config/rtpengine/rtpengine.conf /etc/rtpengine/rtpengine.conf
COPY ./config/kamailio/kamailio.cfg /etc/kamailio/kamailio.cfg
COPY ./config/kamailio/kamctlrc /etc/kamailio/kamctlrc
COPY ./config/kamailio/tls.cfg /etc/kamailio/tls.cfg

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf -u root"]
