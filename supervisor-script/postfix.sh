#!/bin/bash

/usr/sbin/postfix -c /etc/postfix start
sleep 5

while true; do
	pidof master &>/dev/null || exit 1
	sleep 5
done
