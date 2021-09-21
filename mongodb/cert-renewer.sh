#!/bin/sh

step ca renew --daemon --exec "/usr/local/bin/cert-reloader.sh" $TLS_CERT_LOCATION $TLS_KEY_LOCATION &
