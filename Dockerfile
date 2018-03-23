FROM alpine:latest
LABEL maintainer="Glavić <glavic@gmail.com>"

# update / upgrade / add
RUN \
	apk update --no-cache && \
	apk upgrade --no-cache && \
	apk add --no-cache rsyslog bash supervisor postfix opendkim opendkim-utils

# postfix
ADD conf/postfix.conf /etc/postfix/main-override.cf
RUN \
	cd /etc/postfix && \
	cat main.cf main-override.cf > main-sum.cf && \
	mv main-sum.cf main.cf && \
	rm main-override.cf

# openkim
ADD conf/opendkim.conf /etc/opendkim/opendkim.conf
RUN \
	cd /etc/opendkim && \
	touch TrustedHosts KeyTable SigningTable && \
	mkdir keys && \
	touch keys/private && \
	chown -R opendkim:opendkim . && \
	chmod -R 0600 keys

# supervisor
ADD conf/supervisord.conf /etc/supervisor.conf
ADD supervisor-script/ /etc/supervisor-script/
RUN chmod +x /etc/supervisor-script/*.sh

# startup
ADD startup.bash /startup.bash
RUN chmod +x /startup.bash
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor.conf"]

EXPOSE 25
