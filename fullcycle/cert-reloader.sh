#!/bin/sh

redis-cli --tls --insecure config set tls-cert-file /run/secrets/server.crt
