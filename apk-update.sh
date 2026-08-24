#!/bin/sh
# rust:alpine / Alpine apk translation of apt-update.sh
# apt.conf Verify-Peer/Verify-Host "false" for vm0099sim and vm0099sim.army.secret.
# apk has no per-host TLS knobs; --no-check-certificate + SSL_NO_VERIFY_HOSTNAME
# are the global equivalents (no sudo).
set -eu

if [ -f /etc/ssl/certs/ca-certificates.crt ]; then
	cp /etc/ssl/certs/ca-certificates.crt /etc/apk/ca.pem
	export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
	export CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
	export CARGO_HTTP_CAINFO=/etc/ssl/certs/ca-certificates.crt
fi

export SSL_NO_VERIFY_HOSTNAME=1
apk update --no-check-certificate
apk upgrade --no-check-certificate
