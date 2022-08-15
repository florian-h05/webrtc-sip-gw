# webrtc-sip-gw

A [SIP over WebSocket](https://datatracker.ietf.org/doc/html/rfc7118) - [SIP](https://datatracker.ietf.org/doc/html/rfc3261) gateway for the AVM Fritz!Box based on [Kamailio](https://www.kamailio.org/w/) and [rtpengine](https://github.com/sipwise/rtpengine).

SIP over (unsecured) WebSocket is exposed on TCP port 8090.
SIP over secured WebSocket is exposed on TCP port 4443.

Additionally, UDP ports 23400-23500 are exposed for some other communication.

## Important Information

TLS certificate and private key are required at:
- certificate: `/etc/ssl/fullchain.pem`
- private key: `/etc/ssl/privkey.pem`
The provided [docker-compose file](/docker-compose.yml) helps you with mounting those.

The domain of the SIP server is "hard-coded" to `fritz.box`.

## Container Setup Guide

### Directory & Docker Compose File

Create a new directory on your Docker host and place [docker-compose.yml](/docker-compose.yml) there.

`cd` into the new directory.

Create a `ssl` folder.

### Certificate

The certificate should be placed in the `ssl` directory and named `sipgw.crt`.
The private key should also be placed on the `ssl` directory and named `sipgw.key`.

The certificate needs to be installed and trusted on your clients.

If you don't get a certificate from a public CA or have your own private CA,
you need to generate a self-signed certificate.

#### Using OpenSSL to Generate Self-Signed Certificates

OpenSSL is packaged for most Linux distributions, installing it should be as simple as:
```shell
sudo apt install openssl
```

OpenSSL can be told to generate a 2048 bit long RSA key and a certificate that is valid for ten years:
```shell
sudo openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout ./ssl/sipgw.key -out ./ssl/sipgw.crt
```

You will be prompted for some information which you will need to fill out for the certificate, when it asks for a Common Name, you may enter your Docker host's IP Address or hostname.

#### Install & Trust Certificate on Clients

Copy the `sipgw.crt` (only this file, not the key!) to your clients and open the file.

On Android and Windows, a popup with a certificate installation wizard should open up.

On iOS/iPadOS, a popup that tells you to visit the settings should open up.
Visit the settings as told and proceed.
As a final step, follow [Trust manually installed certificate profiles in iOS and iPadOS | Apple Support](https://support.apple.com/en-nz/HT204477).

### Container Start-Up

Execute the following:
```shell
sudo docker-compose up -d
```


