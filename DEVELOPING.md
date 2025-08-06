# webrtc-sip-gw - Development

## Makefile

A Makefile is used to provide a convenient way of executing common tasks:

- `build`: Builds the container image as `webrtc-sip-gateway` using both the commit hash and the branch name and build time as tags.
- `ssl`: Generate self-signed TLS certificate and private key for Kamailio.
- `run`: Start the image as a new container `webrtc-sip-gateway` and attach to it.
- `prune`: Remove dangling `webrtc-sip-gw` images.

### Troubleshooting

The `ssl` goal needs to be run with `sudo` after the container has been running to allow deleting the old certificate and key files.
The container adjusts file permissions of the ssl directory when running, so normal users cannot write to the ssl directory anymore.
