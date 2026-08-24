#!/bin/sh
# rust:alpine: install vm0099sim CA so wget/apk/cargo/curl stop returning SSL error 60.
# Ubuntu's update-ca-certificates accepts a full chain in one .crt.
# Alpine skips any file that is not exactly one cert, so the chain must be split.
# Cargo on rust:* uses libcurl; error 60 is "unable to get local issuer certificate".
set -eu

CERT_DIR=/usr/local/share/ca-certificates
BUNDLE=/etc/ssl/certs/ca-certificates.crt
RAW=/tmp/vm0099sim-raw.crt
SRC_URL=https://vm0099sim/archive/sim.crt

mkdir -p "$CERT_DIR" /etc/ssl/certs /etc/apk /etc/profile.d

fetch_insecure() {
	dest=$1
	url=$2
	if wget --no-check-certificate -O "$dest" "$url"; then
		return 0
	fi
	http_url=$(printf '%s' "$url" | sed 's|^https://|http://|')
	wget -O "$dest" "$http_url"
}

fetch_insecure "$RAW" "$SRC_URL"

if ! grep -q "BEGIN CERTIFICATE" "$RAW"; then
	if command -v openssl >/dev/null 2>&1; then
		openssl x509 -inform DER -in "$RAW" -outform PEM -out "$RAW.pem"
		mv "$RAW.pem" "$RAW"
	else
		echo "sim.crt is not PEM and openssl is not installed" >&2
		exit 1
	fi
fi

# Drop the combined file so Alpine does not skip it, then write one cert per file.
rm -f "$CERT_DIR"/vm0099sim.crt "$CERT_DIR"/vm0099sim-*.crt
awk -v dest="$CERT_DIR" '
	/-----BEGIN CERTIFICATE-----/ {
		n++
		f = sprintf("%s/vm0099sim-%02d.crt", dest, n)
		printing = 1
	}
	printing { print > f }
	/-----END CERTIFICATE-----/ { printing = 0; close(f) }
' "$RAW"

ncerts=0
for c in "$CERT_DIR"/vm0099sim-*.crt; do
	[ -f "$c" ] || continue
	ncerts=$((ncerts + 1))
done
if [ "$ncerts" -eq 0 ]; then
	echo "no PEM certificates found in sim.crt" >&2
	exit 1
fi

update-ca-certificates || true

# Guarantee the certs are in the bundle even if update-ca-certificates skipped them.
if ! grep -q '^# vm0099sim' "$BUNDLE" 2>/dev/null; then
	{
		echo
		echo "# vm0099sim"
		cat "$CERT_DIR"/vm0099sim-*.crt
	} >> "$BUNDLE"
fi

for c in "$CERT_DIR"/vm0099sim-*.crt; do
	[ -f "$c" ] || continue
	base=$(basename "$c" .crt)
	cp "$c" "/etc/ssl/certs/${base}.pem"
done

if [ -L /etc/ssl/cert.pem ]; then
	:
elif [ -f /etc/ssl/cert.pem ]; then
	cp "$BUNDLE" /etc/ssl/cert.pem
else
	ln -sf certs/ca-certificates.crt /etc/ssl/cert.pem
fi

# apk libfetch: if this file exists it replaces the default store, so use the full bundle.
cp "$BUNDLE" /etc/apk/ca.pem

if command -v openssl >/dev/null 2>&1; then
	for c in "$CERT_DIR"/vm0099sim-*.crt; do
		[ -f "$c" ] || continue
		hash=$(openssl x509 -in "$c" -noout -hash 2>/dev/null) || continue
		base=$(basename "$c" .crt)
		ln -sf "${base}.pem" "/etc/ssl/certs/${hash}.0"
	done
fi

export SSL_CERT_FILE=$BUNDLE
export SSL_CERT_DIR=/etc/ssl/certs
export CURL_CA_BUNDLE=$BUNDLE
export GIT_SSL_CAINFO=$BUNDLE
export CARGO_HTTP_CAINFO=$BUNDLE
export REQUESTS_CA_BUNDLE=$BUNDLE
export SSL_NO_VERIFY_HOSTNAME=1
export CARGO_HTTP_CHECK_REVOKE=false

cat >/etc/profile.d/vm0099sim-ca.sh <<EOF
export SSL_CERT_FILE=$BUNDLE
export SSL_CERT_DIR=/etc/ssl/certs
export CURL_CA_BUNDLE=$BUNDLE
export GIT_SSL_CAINFO=$BUNDLE
export CARGO_HTTP_CAINFO=$BUNDLE
export REQUESTS_CA_BUNDLE=$BUNDLE
export SSL_NO_VERIFY_HOSTNAME=1
export CARGO_HTTP_CHECK_REVOKE=false
EOF

cat >/etc/wgetrc <<EOF
ca_certificate = $BUNDLE
ca_directory = /etc/ssl/certs
EOF

cargo_home=${CARGO_HOME:-/usr/local/cargo}
mkdir -p "$cargo_home"
cfg=$cargo_home/config.toml
if [ ! -f "$cfg" ] || ! grep -q 'cainfo' "$cfg" 2>/dev/null; then
	printf '\n[http]\ncainfo = "%s"\ncheck-revoke = false\n' "$BUNDLE" >> "$cfg"
fi

if command -v git >/dev/null 2>&1; then
	git config --system http.sslCAInfo "$BUNDLE" || true
fi

# Alpine translation of apt-update.sh
apk update --no-check-certificate
apk upgrade --no-check-certificate
