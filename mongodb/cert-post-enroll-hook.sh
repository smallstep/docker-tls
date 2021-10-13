#!/bin/bash

cat $TLS_CERT_LOCATION $TLS_KEY_LOCATION > $TLS_PEM_LOCATION
chown mongodb:mongodb $TLS_PEM_LOCATION
