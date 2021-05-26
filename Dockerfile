FROM alpine:3.13.5

# install dump-init
COPY tmp/ /tmp

RUN echo "**** install dumb-init ****" && \
    install -m755 -D /tmp/dumb-init /usr/bin/ && \
    echo "**** install tcpping ****" && \
    install -m755 -D /tmp/tcpping /usr/bin/ && \
    echo "**** install start script ****" && \
    install -m755 -D /tmp/start.sh / && \
    echo "**** install tcping script ****" && \
    install -m755 -D /tmp/tcpping /usr/bin/tcpping && \
    echo "**** clean tmp folder ****" && \
    rm -fr /tmp/*

RUN echo "*** install smokeping ***" && \
    apk --no-cache add smokeping perl-lwp-protocol-https fping tcptraceroute tzdata

RUN echo "*** create fping alias ***" && \
    ln -s /usr/sbin/fping /usr/bin

# Override these environment variables
ENV SLAVE_SECRET=1234567 
ENV MASTER_URL=http://example.com/smokeping/smokeping.cgi
ENV TZ='Asia/Shanghai'

ENTRYPOINT ["/usr/bin/dumb-init", "--", "/start.sh"]
