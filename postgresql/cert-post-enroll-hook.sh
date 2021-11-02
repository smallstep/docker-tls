#!/bin/bash

chown postgres:postgres $TLS_CERT_LOCATION $TLS_KEY_LOCATION
chmod 600 $TLS_KEY_LOCATION
