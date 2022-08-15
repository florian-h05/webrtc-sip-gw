BUILD   ?= $(shell date +%Y%m%d%H%M)
VERSION := 1.0.0-$(BUILD)
IMAGE   := florian-h05/webrtc-sip-gw

build:
	docker buildx build --platform linux/amd64 -t $(IMAGE):latest -t $(IMAGE):$(VERSION) --rm .

push:
	docker push $(IMAGE)

run:
	docker-compose up -d

stop:
	docker-compose down

login:
	docker exec -it webrtc-sip-gw /bin/bash

logs:
	docker-compose logs --follow
