#!/bin/bash

/usr/sbin/rsyslogd
sleep 5

while true; do
	pidof rsyslogd &>/dev/null || exit 1
	sleep 5
done
