FROM alpine:3.17.1

# copy files to tmp
COPY tmp/ /tmp

# build image
RUN echo "*** install softwares ***" && \
    apk --no-cache add openssl ca-certificates-cacert smokeping perl-lwp-protocol-https fping tcptraceroute tzdata s6-overlay patch libcap && \
    echo "**** install tcping script ****" && \
    install -m755 -D /tmp/tcpping /usr/bin/tcpping && \
    echo "*** create fping alias ***" && \
    ln -s /usr/sbin/fping /usr/bin  && \
    echo "*** fping setcap ***" && \
    setcap cap_net_raw+ep /usr/sbin/fping  && \
    echo "**** install service script ****" && \
    mv /tmp/services/* /etc/s6-overlay/s6-rc.d && \
    touch /etc/s6-overlay/s6-rc.d/user/contents.d/smokeping-slave && \
    echo "*** patch smokeping-slave ***" && \
    patch -i /tmp/smokeping-slave.patch -u /usr/share/perl5/vendor_perl/Smokeping/Slave.pm && \
    echo "**** clean tmp folder ****" && \
    rm -fr /tmp/*

# Override these environment variables
ENV SLAVE_SECRET=1234567 
ENV MASTER_URL=http://example.com/smokeping/smokeping.cgi
ENV TZ='Asia/Shanghai'

ENTRYPOINT ["/init"]
