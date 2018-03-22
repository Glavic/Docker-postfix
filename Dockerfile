FROM alpine:latest
LABEL maintainer="Glavić <glavic@gmail.com>"

RUN apk update --no-cache
RUN apk upgrade --no-cache
RUN apk add --no-cache rsyslog bash supervisor postfix opendkim opendkim-utils

# postfix
ADD postfix.conf /etc/postfix/main-docker.cf
RUN \
	cat /etc/postfix/main.cf /etc/postfix/main-docker.cf > /etc/postfix/main-sum.cf && \
	mv /etc/postfix/main-sum.cf /etc/postfix/main.cf && \
	rm /etc/postfix/main-docker.cf

# openkim
ADD opendkim.conf /etc/opendkim/opendkim.conf
RUN touch \
		/etc/opendkim/TrustedHosts \
		/etc/opendkim/KeyTable \
		/etc/opendkim/SigningTable && \
	mkdir /etc/opendkim/keys && \
	chown -R opendkim:opendkim /etc/opendkim && \
	chmod 0600 /etc/opendkim/keys

# supervisor
ADD supervisord.conf /etc/supervisor.conf
ADD supervisor-script/ /etc/supervisor-script/
RUN chmod +x /etc/supervisor-script/*.sh

EXPOSE 25

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor.conf"]
