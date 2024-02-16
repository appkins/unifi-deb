#!/usr/bin/env bash

set -e

if ! [ -f "/etc/matchbox/matchbox.conf" ]; then
  echo "No matchbox.conf file found. Exiting..."
  exit 1
fi

DEST=${TFTP_ROOT:-/var/lib/tftpboot}
MATCHBOX_HOST=${MATCHBOX_HOST:-10.0.0.1}
MATCHBOX_PORT=${MATCHBOX_PORT:-8080}

configure_dnsmasq() {
  if [[ $MATCHBOX_PORT == *443 ]]; then
    SCHEME=https
  else
    SCHEME=http
  fi
  
  if [ -d "/etc/dnsmasq.d" ]; then
    echo "Configuring dnsmasq..."

    cat <<EOF | tee /etc/dnsmasq.d/matchbox.conf
enable-tftp
tftp-root=${DEST}

# Legacy PXE
dhcp-match=set:bios,option:client-arch,0
dhcp-boot=tag:bios,undionly.kpxe

# UEFI
dhcp-match=set:efi32,option:client-arch,6
dhcp-boot=tag:efi32,ipxe.efi
dhcp-match=set:efibc,option:client-arch,7
dhcp-boot=tag:efibc,ipxe.efi
dhcp-match=set:efi64,option:client-arch,9
dhcp-boot=tag:efi64,ipxe.efi

# iPXE - chainload to matchbox ipxe boot script
dhcp-userclass=set:ipxe,iPXE
dhcp-boot=tag:ipxe,${SCHEME}://${MATCHBOX_HOST}:${MATCHBOX_PORT}/boot.ipxe
EOF
  fi
}

configure_ipxe() {
curl -s -o $DEST/undionly.kpxe http://boot.ipxe.org/undionly.kpxe
cp $DEST/undionly.kpxe $DEST/undionly.kpxe.0
curl -s -o $DEST/ipxe.efi http://boot.ipxe.org/ipxe.efi
}

install() {
  echo "Installing matchbox..."
  mkdir -p /var/lib/matchbox
  mkdir -p /var/lib/tftpboot
  mkdir -p /etc/matchbox
  mkdir -p /etc/dnsmasq.d

  cp /matchbox/matchbox /usr/bin/matchbox
  cp /matchbox/boot.ipxe /var/lib/tftpboot/boot.ipxe
  cp /matchbox/matchbox.service /etc/systemd/system/matchbox.service
  cp /matchbox/matchbox.conf /etc/matchbox/matchbox.conf

  configure_dnsmasq

  systemctl daemon-reload
  systemctl enable matchbox
  systemctl start matchbox
}