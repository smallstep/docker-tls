#!/bin/sh
set -e

# first arg is `-f` or `--some-option`
# or first arg is `something.conf`
if [ "${1#-}" != "$1" ] || [ "${1%.conf}" != "$1" ]; then
	    set -- redis-server "$@"
fi

# allow the container to be started with `--user`
if [ "$1" = 'redis-server' -a "$(id -u)" = '0' ]; then
	    find . \! -user redis -exec chown redis '{}' +
		    exec gosu redis "$0" "$@"
fi

if [ -z "$CA_BUNDLE" ]; then
	export CA_BUNDLE=/run/secrets/ca.crt
fi
if [ -z "$CERT_LOCATION" ]; then
	export CERT_LOCATION=/run/secrets/redis.crt
fi
/certwatch.sh &

exec "$@"
