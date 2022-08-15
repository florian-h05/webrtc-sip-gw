# webrtc-sip-gw

## Development

Clone this repository, then use the available `sudo make` commands:
- `build`: Builds the container image.
- `push`: Push to the container registry.
- `run`: Start the image as a new container with name `webrtc-sip-gateway`.
- `stop`: Stop the container.
- `login`: Login to the container's shell.
- `logs`: Show the container's logs.

### Troubleshooting

#### `buildx` is not working

When you get an error message like `'buildx' is not a docker command.`, 
[Install Docker Buildx | Docker Documentation](https://docs.docker.com/build/buildx/install/) might help.
