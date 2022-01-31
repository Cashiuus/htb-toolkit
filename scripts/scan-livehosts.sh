#!/bin/bash


echo -n "Enter first 3 octets of scan range (e.g. 10.0.1): "
read NET_RANGE
echo ""

for ip in $(seq 1 254); do
    ping -c 1 -W2 $NET_RANGE.$ip | grep "bytes from" | cut -d " " -f4 | cut -d ":" -f1 &
done


#for ip in 10.10.110.{1..254};do
#    ping -c 1 -W1 $ip | grep "bytes from" | cut -d" " -f4
#done
