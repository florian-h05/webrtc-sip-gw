# webrtc-sip-gw

A [SIP over WebSocket](https://datatracker.ietf.org/doc/html/rfc7118) - [SIP](https://datatracker.ietf.org/doc/html/rfc3261) gateway for the AVM Fritz!Box based on [Kamailio](https://www.kamailio.org/w/) and [rtpengine](https://github.com/sipwise/rtpengine).

This gateway allows any SIP user of your Fritz!Box to perform calls with SIP over WebSocket, which is unsupported by the Fritz!Box.

## Important Information

### Requirements

TLS certificate and private key are required at:
- certificate: `/etc/ssl/fullchain.pem`
- private key: `/etc/ssl/privkey.pem`
The provided [docker-compose file](/docker-compose.yml) helps you with mounting those.

The domain of the SIP server is "hard-coded" to `fritz.box`.

### Ports

SIP over (unsecured) WebSocket is exposed on TCP port 8090.
SIP over secured WebSocket is exposed on TCP port 4443.

Additionally, UDP ports 23400-23500 are exposed for some other communication.

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

OpenSSL can be told to generate a 2048 bit long RSA key and a certificate that is valid for 825 days, but there are some important requirements:
- You have any hostname for the CN (common name) of the certificate. Enter this hostname when OpenSSL asks for `Common Name (e.g. server FQDN or YOUR name) []:`. It is not required that the server can be reached under this hostname, but the certificate must have a hostname as CN.
- Replace `<IP-ADDRESS>` with your server's IP address.
- Replace `<ADDITIONAL-HOSTNAME>` with another hostname the certificate should be valid for, or delete `,DNS:<ADDITIONAL-HOSTNAME>`.
```shell
openssl req -x509 -nodes -days 825 -newkey rsa:2048 -addext 'subjectAltName=IP:<IP-ADDRESS>,DNS:<ADDITIONAL-HOSTNAME>' -addext 'keyUsage = digitalSignature,keyEncipherment' -addext 'extendedKeyUsage = serverAuth' -keyout ./ssl/sipgw.key -out ./ssl/sipgw.crt
```

This certificat follows the [Requirements for trusted certificates in iOS 13 and macOS 10.15](https://support.apple.com/en-us/HT210176).
Key usage and extended key usage are set as defined in [RFC5280](https://www.rfc-editor.org/rfc/rfc5280#section-4.2.1.12).

You will be prompted for some information which you will need to fill out for the certificate, please remember to fill in a hostname when it asks for Common Name.

### Container Start-Up

Execute the following:
```shell
sudo docker-compose up -d
```

The following error messages can be ignored during startup:
```text
ERROR: rtpengine [rtpengine.c:2887]: send_rtpp_command(): can’t send command „ping“ to RTPEngine <udp:127.0.0.1:22222>
ERROR: rtpengine [rtpengine.c:2788]: rtpp_test(): proxy did not respond to ping
```

## Client Setup Guide

#### Install & Trust Certificate on Clients

Copy the `sipgw.crt` (only this file, not the key!) to your clients and open the file.

On Android and Windows, a popup with a certificate installation wizard should open up.

On iOS/iPadOS, a popup that tells you to visit the settings should open up.
Visit the settings as told and proceed.

#### openHAB MainUI Setup

Using the [`oh-sipclient`](https://openhab.org/docs/ui/components/oh-sipclient.html) component or widget, use the following configuration:
- `websocketUrl`: `wss://YOUR-DOCKER-HOST:4443`
- `domain`: `fritz.box`
- `username`: any valid SIP user in your Fritz!Box
- `password`: password of your valid SIP user
