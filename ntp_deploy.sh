#!/bin/bash
#
# >/dev/null redirects the command standard output to the null device, 
# which is a special device which discards the information written to it. 
# 2 >&1 redirects the standard error stream
# to the standard output stream (stderr = 2, stdout = 1).
#
exec 1 > /dev/null 2 >&1

#Go to the work directory
workdirectory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

#Check the installed NTP
if [ $(dpkg-query --show ntp 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
  apt-get install ntp -y;
fi

#Edit .conf file with back up
sed --in-place=.backup 's/0.ubuntu.pool.ntp.org/ua.pool.ntp.org/g' /etc/ntp.conf
sed --in-place=.backup '/.ubuntu.pool.ntp.org/d' /etc/ntp.conf

#Restart NTP
service ntp restart

#Verify cron
SCR="$workdirectory/ntp_verify.sh"
JOB="*/1 * * * * $SCR MAILTO=root@localhost"
TMPC="mycron"
grep "$SCR" -q <(crontab -l) || (crontab -l>"$TMPC"; echo "$JOB">>"$TMPC"; crontab "$TMPC")
rm mycron

#Back up NTP .conf
cat /etc/ntp.conf > /etc/ntp.conf.bak

exit 0
