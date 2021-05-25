FROM linuxserver/smokeping

# copy tcpping script
COPY tcpping /defaults/

# add local files
RUN mkdir /cache && \
    chown abc /cache && \
    chmod +s /usr/bin/tcptraceroute && \
    rm -rf /etc/services.d/apache && \
    apk add --no-cache perl-lwp-protocol-https && \
    echo "**** install tcping script ****" && \
    install -m755 -D /defaults/tcpping /usr/bin/ && \
    echo "**** create alias for fping ****" && \
    ln -s /usr/sbin/fping /usr/bin/fping

COPY root/ /


# Override these environment variables
ENV SLAVE_SECRET=1234567 
ENV MASTER_URL=http://smokeping-master:80/smokeping/smokeping.cgi
