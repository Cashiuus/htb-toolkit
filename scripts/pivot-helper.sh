#!/bin/bash
# Change the IP subnet CIDR below to suit the network you are trying to reach
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A OUTPUT -p tcp -d 172.16.1.0/24 -j REDIRECT --to-ports 12345
iptables -t nat -A PREROUTING -p tcp -d 172.16.1.0/24 -j REDIRECT --to-ports 12345
/usr/sbin/redsocks -c /etc/redsocks.conf
