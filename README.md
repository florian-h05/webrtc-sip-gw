# webrtc-sip-gw

A [SIP over WebSocket](https://datatracker.ietf.org/doc/html/rfc7118) - [SIP](https://datatracker.ietf.org/doc/html/rfc3261) gateway for the AVM Fritz!Box based on [Kamailio](https://www.kamailio.org/w/) and [rtpengine](https://github.com/sipwise/rtpengine).

SIP over (unsecured) WebSocket is exposed on TCP port 8090.
SIP over secured WebSocket is exposed on TCP port 4443.

## Configuration

TLS certicate and key are required.

## How to use?

It is recommended to use the following *docker-compose.yml* file:

```yaml
version: "3.3"

services:
  webrtc-sip-gw:
    container_name: webrtc-sip-gw
    image: ghcr.io/florian-h05/webrtc-sip-gw
    restart: always
    network_mode: host
    volumes:
     - ./ssl/private.key:/etc/ssl/privkey.pem:ro
     - ./ssl/cert.pem:/etc/ssl/fullchain.pem:ro
```
