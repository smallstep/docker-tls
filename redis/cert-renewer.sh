#!/bin/sh

step ca renew --daemon --exec "/usr/local/bin/cert-post-renew-hook.sh" $TLS_CERT_LOCATION $TLS_KEY_LOCATION &
