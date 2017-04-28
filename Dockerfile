FROM alpine:3.4
MAINTAINER Brendan Beveridge "brendan@nodeintegration.com.au"
RUN apk add --no-cache rsyslog rsyslog-tls
EXPOSE 514 514/udp
ADD rsyslog.conf /etc/rsyslog.conf

ENV TLS_ENABLE false

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD [ "rsyslogd", "-n" ]