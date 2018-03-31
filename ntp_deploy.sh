#!/bin/bash
#
# >/dev/null redirects the command standard output to the null device, 
# which is a special device which discards the information written to it. 
# 2 >&1 redirects the standard error stream
# to the standard output stream (stderr = 2, stdout = 1).
#

#Install NTP
apt-get update >> /dev/null 2>&1 && apt-get install -y ntp >> /dev/null 2>&1

#Edit .config NTP
sed -i '/ntp_verify.sh/d' /etc/crontab
sed -i '/ua.pool.ntp.org/d' /etc/ntp.conf
sed -i 's/^pool/#pool/g' /etc/ntp.conf
sed -i 's/^server/#server/g' /etc/ntp.conf
sed -i '/pool 3./a \pool ua.pool.ntp.org iburst' /etc/ntp.conf
if  [ -f /etc/ntp.conf.bak ]; then rm /etc/ntp.conf.bak; fi
cp /etc/ntp.conf /etc/ntp.conf.bak

#Restart NTP
service ntp restart

#Add to cron
echo "*/1 *	* * *   root    $(pwd)/ntp_verify.sh	# NTP Service" >> /etc/crontab
