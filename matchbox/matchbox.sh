#!/usr/bin/env bash

source /etc/matchbox/matchbox.conf

set -e


configure_dnsmasq() {
  if [ -d "/etc/dnsmasq.d" ]; then
    echo "Configuring dnsmasq..."
  fi
  if [ -f "/etc/dnsmasq.conf" ]; then
    echo "Configuring dnsmasq..."
    echo "dhcp-range=${MATCHBOX_DHCP_RANGE}" >> /etc/dnsmasq.conf
    echo "dhcp-option=option:router,${MATCHBOX_IP}" >> /etc/dnsmasq.conf
    echo "dhcp-option=option:dns-server,${MATCHBOX_IP}" >> /etc/dnsmasq.conf
    echo "dhcp-option=option:ntp-server,${MATCHBOX_IP}" >> /etc/dnsmasq.conf
    echo "dhcp-option=option:domain-name,${MATCHBOX_DOMAIN}" >> /etc/dnsmasq.conf
    echo "dhcp-option=option:domain-search,${MATCHBOX_DOMAIN}" >> /etc/dnsmasq.conf
  fi
}

/usr/bin/matchbox