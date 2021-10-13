#!/bin/bash
set -e

/usr/local/bin/cert-enroller.sh
if [ "$?" -eq 0 ]; then
	/usr/local/bin/cert-renewer.sh &
fi

ls -la /usr/local/bin/docker-entrypoint.sh
/usr/local/bin/docker-entrypoint.sh "$@"
