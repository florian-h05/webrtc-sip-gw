BUILD   ?= $(shell date +%Y%m%d%H%M)
VERSION := 1.0.0-$(BUILD)
IMAGE   := florian-h05/webrtc-sip-gw

build:
	docker buildx build --platform linux/amd64 -t $(IMAGE):latest -t $(IMAGE):$(VERSION) --rm .

push:
	docker push $(IMAGE)

run:
	docker run --rm -d --network host --name webrtc-sip-gw florian-h05/webrtc-sip-gw:latest

stop:
	docker container stop webrtc-sip-gw

login:
	docker exec -it webrtc-sip-gw /bin/bash

logs:
	docker logs --follow webrtc-sip-gw
