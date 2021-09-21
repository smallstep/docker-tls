#!/bin/sh

redis-cli --tls --insecure config set tls-cert-file $TLS_CERT_LOCATION
