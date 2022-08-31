#!/bin/bash
curl --include --no-buffer --header "Connection: Upgrade" --header "Upgrade: websocket" http://FILL_MY_IP:8090 || exit 1
