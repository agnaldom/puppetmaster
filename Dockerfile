FROM debian:8

MAINTAINER  Agnaldo Marinho  <agnaldomarinho7@gmail.com>

RUN set -x; \
    apt-get update \
    && apt-get install -y --no-install-recommends \
    puppetmaster \
    && rm -rf /var/lib/apt/lists/*

ADD puppet.conf /etc/puppet/puppet.conf

RUN mkdir -p /opt/puppet/etc /opt/puppet/var/log

VOLUME ["/opt/puppet"]

RUN cp -rf /etc/puppet/* /opt/puppet/etc/

RUN cp -rf /var/lib/puppet/* /opt/puppet/var/

EXPOSE 8140 

ENTRYPOINT [ "/usr/bin/puppet", "master", "--no-daemonize", "--verbose" ]
