FROM debian:12-slim

# Create users and groups
RUN useradd -u 1500 --no-create-home -s /bin/false rtpengine && \
    useradd -u 1501 --no-create-home -s /bin/false kamailio

# Install dependencies and useful tools
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y supervisor nano

# Install Kamailio and rtpengine
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y rtpengine && \
  DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y kamailio kamailio-websocket-modules kamailio-tls-modules kamailio-presence-modules kamailio-outbound-modules

# Copy entrypoint and healthcheck scripts
COPY ./entrypoint /entrypoint
COPY ./healthcheck /healthcheck

# Copy configuration
COPY ./config/supervisor-rtpengine.conf /etc/supervisor/conf.d/rtpengine.conf
COPY ./config/supervisor-kamailio.conf /etc/supervisor/conf.d/kamailio.conf
COPY --chown=rtpengine:rtpengine ./config/rtpengine/rtpengine.conf /etc/rtpengine/rtpengine.conf
COPY --chown=kamailio:kamailio ./config/kamailio/kamailio.cfg /etc/kamailio/kamailio.cfg
COPY --chown=kamailio:kamailio ./config/kamailio/kamctlrc /etc/kamailio/kamctlrc
COPY --chown=kamailio:kamailio ./config/kamailio/tls.cfg /etc/kamailio/tls.cfg

# Create necessary directories
RUN mkdir -p /var/run/rtpengine && \
    chown rtpengine:rtpengine /var/run/rtpengine && \
    mkdir -p /var/run/kamailio && \
    chown kamailio:kamailio /var/run/kamailio

HEALTHCHECK --interval=30s --timeout=5s --retries=3 CMD sh /healthcheck

ENTRYPOINT ["/entrypoint"]

CMD ["/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf -u root"]
