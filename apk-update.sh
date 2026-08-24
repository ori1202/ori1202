#!/bin/sh
# rust:alpine / Alpine apk translation of apt-update.sh
# apt.conf Verify-Peer/Verify-Host "false" for vm0099sim and vm0099sim.army.secret.
# apk has no per-host TLS knobs; --no-check-certificate + SSL_NO_VERIFY_HOSTNAME
# are the global equivalents (no sudo).
set -eu

export SSL_NO_VERIFY_HOSTNAME=1
apk update --no-check-certificate
apk upgrade --no-check-certificate
