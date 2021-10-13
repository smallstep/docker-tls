#!/bin/bash
set -e

/usr/local/bin/cert-enroller.sh
if [ "$?" -eq 0 ]; then
	/usr/local/bin/cert-renewer.sh &
fi

/usr/local/bin/docker-entrypoint.sh "$@"
