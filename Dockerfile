FROM alpine:latest
LABEL maintainer="Glavić <glavic@gmail.com>"

RUN apk update --no-cache
RUN apk upgrade --no-cache
RUN apk add --no-cache rsyslog bash supervisor postfix opendkim opendkim-utils

# DEBUG, remove when ready to deploy
# https://github.com/catatnight/docker-postfix
# https://github.com/nickstenning/dockerfiles/blob/master/rt/supervisord.conf
RUN apk add --no-cache nano busybox-extras

# postfix
ADD postfix.conf /etc/postfix/main.cf

# openkim
ADD opendkim.conf /etc/opendkim/opendkim.conf
RUN touch \
	/etc/opendkim/TrustedHosts \
	/etc/opendkim/KeyTable \
	/etc/opendkim/SigningTable

# supervisor
ADD supervisor-script/ /etc/supervisor-script/
RUN chmod +x /etc/supervisor-script/*.sh
ADD supervisord.conf /etc/supervisor.conf

EXPOSE 25

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor.conf"]
