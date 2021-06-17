BUILD   ?= $(shell date +%Y%m%d%H%M)
VERSION := 0.0.1-$(BUILD)
IMAGE   := nanosonde/webrtc-gw

.PHONY: all build push
all: build push

build:
	docker buildx build --push --platform linux/amd64 -t $(IMAGE):latest -t $(IMAGE):$(VERSION) --rm .
	#docker build -t 'webrtc-gw:latest' --rm .

push:
	docker push $(IMAGE)

run:
	docker run --rm -d --network host --name webrtc-gw webrtc-gw:latest

stop:
	docker container stop webrtc-gw

login:
	docker exec -it webrtc-gw /bin/bash

