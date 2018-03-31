#!/bin/bash

#Go to working directory
cd "$( dirname "${BASH_SOURCE[0]}" )"
DIRECTORY="$(pwd)"

# Check ntpd running
VNTP=$(ps ax | grep ntpd | wc -l)
if [ ${VNTP} -le 1 ]
then
        echo "NOTICE: ntp is not running"
        echo "Starting the ntp service..."
        $DIRECTORY/ntp_deploy.sh
        if [ $? -eq 0 ]
        then
                echo "ntp service is run"
        fi
fi

# Check ntp .conf
VDIFF=$(diff -u /etc/ntp.conf /etc/ntp.conf.backup | wc -l)
if [ ${VDIFF} -gt 0 ]; then
        echo "NOTICE: /etc/ntp.conf was changed. Calculated diff:"
        DIFF=$(diff -u /etc/ntp.conf /etc/ntp.conf.backup | grep -v "^\ #")
        echo -e "$DIFF"
        cp /etc/ntp.conf.backup /etc/ntp.conf
        service ntp restart
fi;

exit 0
