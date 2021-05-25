FROM archlinux/archlinux:latest

# install dump-init
COPY tmp/ /tmp

# WORKAROUND for glibc 2.33 and old Docker
# See https://github.com/actions/virtual-environments/issues/2658
# Thanks to https://github.com/lxqt/lxqt-panel/pull/1562
RUN patched_glibc=glibc-linux4-2.33-4-x86_64.pkg.tar.zst && \
    curl -LO "https://repo.archlinuxcn.org/x86_64/$patched_glibc" && \
    bsdtar -C / -xvf "$patched_glibc"

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
