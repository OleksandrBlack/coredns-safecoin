#!/bin/bash

systemctl stop systemd-resolved

if [ ! -d /etc/dnsseeder ]; then
    mkdir -p /etc/dnsseeder
fi

cat <<EOF > /etc/dnsseeder/Corefile
mainnet.seeder.example.com {
    dnsseed {
        network mainnet
        bootstrap_peers dnsseed.local.support:8770 dnsseed.fair.exchange:8770 explorer.safecoin.org:8770
        crawl_interval 30m
        record_ttl 600
    }
}

testnet.seeder.example.com {
    dnsseed {
        network testnet
        bootstrap_peers testnet.safecoin.org:18770
        crawl_interval 15m
        record_ttl 300
    }
}
EOF
