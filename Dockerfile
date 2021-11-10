FROM alpine:3.14

# update / upgrade / add
RUN \
	apk update --no-cache && \
	apk upgrade --no-cache && \
	apk add --no-cache rsyslog bash supervisor postfix opendkim opendkim-utils ca-certificates

# postfix
COPY conf/postfix.conf /etc/postfix/main-override.cf
RUN \
	cd /etc/postfix && \
	cat main.cf main-override.cf > main-sum.cf && \
	mv main-sum.cf main.cf && \
	rm main-override.cf

# openkim
COPY opendkim/ /etc/opendkim/
RUN mkdir /etc/opendkim/keys

# supervisor
COPY conf/supervisord.conf /etc/supervisor.conf
COPY supervisor-script/ /etc/supervisor-script/
RUN chmod +x /etc/supervisor-script/*.sh

# startup
COPY startup.bash /startup.bash
RUN chmod +x /startup.bash
CMD ["/startup.bash"]

EXPOSE 25
