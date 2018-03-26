#!/bin/bash

if [[ -z "${DKIM_DOMAIN}" ]] || [[ -z "${DKIM_SELECTOR}" ]]; then
    echo "Please set DKIM_DOMAIN and DKIM_SELECTOR environment variables."
    exit 1
fi

echo -e "\e[32mDKIM_* variables:\e[39m"
echo -e "   DKIM_DOMAIN = ${DKIM_DOMAIN}"
echo -e "   DKIM_SELECTOR = ${DKIM_SELECTOR}"
echo

if [[ ! -f "/etc/opendkim/keys/${DKIM_SELECTOR}.private" ]]; then
    echo -e "\e[32mNo opendkim key found; generation new one ...\e[39m"
    opendkim-genkey \
        -b 1024 \
        -d ${DKIM_DOMAIN} \
        -D /etc/opendkim/keys \
        -h sha256 \
        -r \
        -s ${DKIM_SELECTOR} \
        -v
    echo

    echo -e "\e[32mSet DNS setting to:\e[39m"
    cat /etc/opendkim/keys/${DKIM_SELECTOR}.txt
    echo
fi

echo -e "\e[32mReplacing:\e[39m"
cat /etc/opendkim/*Table
echo -e "\e[32mto:\e[39m"
sed -i -- "s/{{DKIM_DOMAIN}}/${DKIM_DOMAIN}/g" /etc/opendkim/*Table
sed -i -- "s/{{DKIM_SELECTOR}}/${DKIM_SELECTOR}/g" /etc/opendkim/*Table
cat /etc/opendkim/*Table
echo

chown -R opendkim:opendkim /etc/opendkim
chmod -R 0700 /etc/opendkim/keys

/usr/bin/supervisord -c /etc/supervisor.conf

echo -e "\e[32mTailing /var/log/maillog ...\e[39m"
tail -F /var/log/maillog
