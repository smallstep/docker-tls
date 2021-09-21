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

/usr/local/bin/cert-enroller.sh
if [ "$?" -eq 0 ]; then
	/usr/local/bin/cert-renewer.sh &
fi

# TODO: Potentially add --tls flags to redis ($@) here.

exec "$@"
