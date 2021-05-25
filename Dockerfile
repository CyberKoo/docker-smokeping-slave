FROM archlinux/archlinux:latest

# install dump-init
COPY tmp/ /tmp

RUN echo "**** install dumb-init ****" && \
    install -m755 -D /tmp/dumb-init /usr/bin/ && \
    echo "**** install tcpping ****" && \
    install -m755 -D /tmp/tcpping /usr/bin/ && \
    echo "**** install start script ****" && \
    install -m755 -D /tmp/start.sh /

# add local files
RUN yes | pacman -Sy smokeping perl-lwp-protocol-https fping traceroute && \
    echo "**** install tcping script ****" && \
    install -m755 -D /tmp/tcpping /usr/bin/ && \
    yes | pacman -Scc

# Override these environment variables
ENV SLAVE_SECRET=1234567 
ENV MASTER_URL=http://smokeping-master:80/smokeping/smokeping.cgi

ENTRYPOINT ["/usr/bin/dumb-init", "--", "/start.sh"]
