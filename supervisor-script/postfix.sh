#!/bin/bash

/usr/sbin/postfix -c /etc/postfix start
sleep 5

postconf -e milter_protocol=6
postconf -e milter_default_action=accept
postconf -e smtpd_milters=inet:localhost:12301
postconf -e non_smtpd_milters=inet:localhost:12301

while true; do
	pidof master &>/dev/null || exit 1
	sleep 5
done
