#!/bin/sh

# wait for redis to start up
sleep 30
CERT_LOCATION=$(redis-cli --tls --insecure --raw config get tls-cert-file | tail -n1)

while true; do
	if [ -e $CERT_LOCATION ]; then
		inotifywait -e modify $CERT_LOCATION
		redis-cli --tls --insecure config set tls-cert-file $CERT_LOCATION
	fi
	sleep 10
done

