FROM debian:stretch-slim

LABEL maintainer="Rob Pickering <rob@aplisay.uk>"

ENV ASTERISK_VERSION 16-current
ENV OPUS_CODEC asterisk-16.0/x86-64/codec_opus-16.0_current-x86_64

COPY build.sh /
COPY templates /templates
RUN /build.sh

EXPOSE 5060/udp 5061/tcp 8080/tcp 8443/tcp
VOLUME /var/spool/asterisk /var/log/asterisk

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/asterisk", "-vvvdddf", "-T", "-W", "-U", "asterisk", "-p"]
