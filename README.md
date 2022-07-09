# webrtc-gw

A [SIP over WebSocket](https://datatracker.ietf.org/doc/html/rfc7118) - [SIP](https://datatracker.ietf.org/doc/html/rfc3261) gateway for the AVM Fritz!Box based on [Kamailio](https://www.kamailio.org/w/) and [rtpengine](https://github.com/sipwise/rtpengine).

SIP over (unsecured) WebSocket is exposed on TCP port 8090.

## Configuration

No configuration is required.

## How to use?

Clone this repository, then use the available `sudo make` commands:
- `build`: Builds the container image.
- `push`: Push to the container registry.
- `run`: Start the image as a new container with name `webrtc-sip-gateway`.
- `stop`: Stop the container.
- `login`: Login to the container's shell.
- `logs`: Show the container's logs.
