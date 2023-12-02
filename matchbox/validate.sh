#!/usr/bin/env bash

set -e

if ! [ -f "/etc/matchbox/matchbox.conf" ]; then
  echo "No matchbox.conf file found. Exiting..."
  exit 1
fi

source /etc/matchbox/matchbox.conf

CERT_FILE="${MATCHBOX_CERT_FILE:-/etc/matchbox/server.crt}"
KEY_FILE="${MATCHBOX_KEY_FILE:-/etc/matchbox/server.key}"
CA_FILE="${MATCHBOX_CA_FILE:-/etc/matchbox/ca.crt}"

if ! { [ -f "$CERT_FILE" ] || [ -f "$KEY_FILE" ] || [ -f "$CA_FILE" ]; }; then
  if ! { [ -z "$MATCHBOX_DOMAIN" ] || [ -z "$MATCHBOX_IP" ]; }; then
    echo "No certificate files found. Generating new ones..."
    if [ -f "/var/lib/matchbox/scripts/tls/cert-gen" ]; then
      env --chdir=/var/lib/matchbox/scripts/tls SAN="DNS.1:${MATCHBOX_HOST},IP.1:${MATCHBOX_IP}" bash ./cert-gen
      mv /var/lib/matchbox/scripts/tls/*.{crt,key} /etc/matchbox/
      if ! [ -d "/etc/matchbox" ]; then
        mkdir -p /etc/matchbox
      fi
      mv /var/lib/matchbox/scripts/tls/*.{crt,key} /etc/matchbox/
    else
      echo "No cert-gen file found. Exiting..."
      exit 1
    fi
  fi
else
  echo "Certificate files found. Skipping generation..."
fi
