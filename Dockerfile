FROM debian:8

MAINTAINER  Agnaldo Marinho  <agnaldomarinho7@gmail.com>

RUN set -x; \
    apt-get update \
    && apt-get install -y --no-install-recommends \
    puppetmaster \
    && rm -rf /var/lib/apt/lists/*

ADD puppet.conf /etc/puppet/puppet.conf
ADD entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

VOLUME ["/opt/puppet/etc", "/opt/puppet/var/", "/opt/puppet/var/log/"]

EXPOSE 8140 

ENTRYPOINT ["/entrypoint.sh"]
