FROM debian:8

MAINTAINER  Agnaldo Marinho  <agnaldomarinho7@gmail.com>

RUN set -x; \
    apt-get update \
    && apt-get install -y --no-install-recommends \
    puppetmaster \
    && rm -rf /var/lib/apt/lists/*

ADD puppet.conf /etc/puppet/puppet.conf

RUN mkdir /opt/puppet/

RUN mkdir -p /opt/puppet/etc/ && mkdir -p /opt/puppet/var/log/

RUN cp -rf /etc/puppet/* /opt/puppet/etc/

RUN cp -rf /var/lib/puppet/* /opt/puppet/var/

VOLUME ["/opt/puppet/etc" "/opt/puppet/var/" "/opt/puppet/var/log/"]

EXPOSE 8140 

ENTRYPOINT [ "/usr/bin/puppet", "master", "--no-daemonize", "--verbose" ]
