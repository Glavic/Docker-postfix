#!/bin/bash

/usr/sbin/opendkim -x /etc/opendkim/opendkim.conf
sleep 5

while true; do
	pidof opendkim &>/dev/null || exit 1
	sleep 5
done
