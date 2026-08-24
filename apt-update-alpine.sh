#!/bin/sh
# rust:alpine bootstrap: no sudo/curl; busybox wget is on PATH.
set -eu

mkdir -p /usr/local/share/ca-certificates
wget --no-check-certificate -O /usr/local/share/ca-certificates/vm0099sim.crt https://vm0099sim/archive/sim.crt
update-ca-certificates
wget --no-check-certificate -O apt-update.sh https://vm0099sim/archive/apt-update.sh
sh apt-update.sh
