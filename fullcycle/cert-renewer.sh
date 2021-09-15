#!/bin/sh

step ca renew --daemon --exec "/certreload.sh" /run/secrets/server.crt /run/secrets/server.key &
