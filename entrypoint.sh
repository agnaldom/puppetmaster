#!/bin/bash
set -e


[[ -n $DEBUG_ENTRYPOINT ]] && set -x

PUPPETDIR=/opt/puppet/
if [ '$(ls -A "$PUPPETDIR/etc/)"' ]; then
	puppet master --confdir "/opt/puppet/etc" --verbose --no-daemonize
else
	mkdir -p $PUPPETDIR/etc && mkdir -p $PUPPETDIR/var/log && \
	cp -rf /etc/puppet/* $PUPPETDIR/etc/ && \
	cp -rf /var/lib/puppet/* $PUPPETDIR/var/
	puppet master --confdir "/opt/puppet/etc" --verbose --no-daemonize
fi


