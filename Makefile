BUILD   ?= $(shell date +%Y%m%d%H%M)
TAG     ?= $(shell git describe --tags --abbrev=0)
VERSION := $(TAG)-$(BUILD)
IMAGE   := ghcr.io/florian-h05/webrtc-sip-gw

build:
	docker buildx build --platform linux/amd64 -t $(IMAGE):latest -t $(IMAGE):$(VERSION) --rm --load .

push:
	docker push $(IMAGE)

start:
	docker compose up -d

stop:
	docker compose down

login:
	docker exec -it webrtc-sip-gw /bin/bash

logs:
	docker compose logs --follow
