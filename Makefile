BUILD   ?= $(shell date +%Y%m%d%H%M)
BRANCH  ?= $(shell git rev-parse --abbrev-ref HEAD)
SHA     ?= $(shell git rev-parse --short HEAD)
VERSION := $(TAG)-$(BUILD)
IMAGE   := webrtc-sip-gw

IP ?= $(shell hostname -I | awk '{print $$1}')
HOSTNAME ?= $(shell hostname)

# Declare targets as phony to avoid conflicts with files of the same name
.PHONY: all build ssl run prune

build:
	docker build -t $(IMAGE):$(BRANCH)-$(BUILD) -t $(IMAGE):$(SHA) .

ssl:
	rm -rf ./ssl
	mkdir -p ./ssl
	openssl req -x509 -nodes -days 825 -newkey rsa:2048 \
		-subj "/CN=$(HOSTNAME)" \
		-addext "subjectAltName=IP:$(IP),DNS:$(HOSTNAME)" \
		-addext "keyUsage = digitalSignature,keyEncipherment" \
		-addext "extendedKeyUsage = serverAuth" \
		-keyout ./ssl/privkey.pem \
		-out ./ssl/fullchain.pem

run:
	docker run \
		--name webrtc-sip-gw \
		--network host \
		--rm \
		-v $(CURDIR)/ssl:/etc/ssl/kamailio \
		-e TLS_DISABLE=false \
		-e MY_IP=$(IP) \
		-e MY_HOSTNAME=$(HOSTNAME) \
		$(IMAGE):$(SHA)

prune:
	docker image ls --filter=reference='webrtc-sip-gw*' -q | xargs -r docker rmi
