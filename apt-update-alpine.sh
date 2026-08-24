#!/bin/sh
# rust:alpine bootstrap: no sudo/curl; busybox wget is on PATH.
set -eu

mkdir -p /usr/local/share/ca-certificates
wget --no-check-certificate -O /usr/local/share/ca-certificates/vm0099sim.crt https://vm0099sim/archive/sim.crt
update-ca-certificates

# Alpine translation of apt-update.sh (apt.conf.d + apt update/upgrade).
export SSL_NO_VERIFY_HOSTNAME=1
apk update --no-check-certificate
apk upgrade --no-check-certificate
