#!/bin/bash
# Sketch of a working deployment of the DNS seeder with systemd

set -uxeo pipefail

mkdir /etc/dnsseeder
mkdir /etc/systemd/resolved.conf.d/

cp build_output/coredns /etc/dnsseeder/coredns
cp coredns/Corefile /etc/dnsseeder/Corefile

cat <<EOF >> /etc/dnsseeder/Corefile
# Replace systemd-resolved so we can bind .:53 without breaking the system DNS.
# Load-balances forwarded queries across Cloudflare and both Google DNS servers
. {
    bind 127.0.0.53
    cache 120
    forward . 1.1.1.1 8.8.8.8 8.8.4.4
}
EOF

cp systemd/dnsseeder.service /etc/dnsseeder/
cp systemd/10-resolved-override.conf /etc/dnsseeder/

ln -s /etc/dnsseeder/dnsseeder.service /etc/systemd/system/
ln -s /etc/dnsseeder/dnsseeder.service /etc/systemd/system/multi-user.target.wants/
ln -s /etc/dnsseeder/10-resolved-override.conf /etc/systemd/resolved.conf.d/

systemctl daemon-reload
systemctl stop systemd-resolved
systemctl start dnsseeder
systemctl start systemd-resolved