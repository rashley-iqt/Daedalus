#!/bin/sh

ip tuntap add name ogstun mode tun
ip addr add 10.11.0.1/16 dev ogstun
ip link set ogstun up
ip tuntap add name ogstun2 mode tun
ip addr add 10.12.0.1/16 dev ogstun2
ip link set ogstun2 up

# masquerade
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -I INPUT -i ogstun -j ACCEPT
iptables -I INPUT -i ogstun2 -j ACCEPT

mkdir -p /usr/local/var/log/open5gs
touch /usr/local/var/log/open5gs/upf2.log

tail -f /usr/local/var/log/open5gs/upf2.log &

open5gs-upfd -c /usr/local/etc/open5gs/upf2.yaml
