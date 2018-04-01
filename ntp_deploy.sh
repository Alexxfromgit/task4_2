#!/bin/bash

apt-get update >> /dev/null 2>&1 && apt-get install -y ntp >> /dev/null 2>&1

sed -i '/ntp_verify.sh/d' /etc/crontab
sed -i '/ua.pool.ntp.org/d' /etc/ntp.conf
sed -i 's/^pool/#pool/g' /etc/ntp.conf
sed -i 's/^server/#server/g' /etc/ntp.conf
sed -i '/pool 3./a \pool ua.pool.ntp.org iburst' /etc/ntp.conf
if  [ -f /etc/ntp.conf.bak ]; then rm -rf /etc/ntp.conf.bak; fi
cp /etc/ntp.conf /etc/ntp.conf.bak

service ntp restart

echo "*/1 *	* * *   root    $(pwd)/ntp_verify.sh	# NTP Service" >> /etc/crontab
