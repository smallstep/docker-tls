#!/bin/sh

# Discover an ACME provisioner
if [ -z "$CA_PROVISIONER_NAME" ]; then
	provisioner=$(step ca provisioner list | jq -r '[.[] | select(.type == "ACME") | .name][0]')
	if [ "$provisioner" != "null" ]; then
		CA_PROVISIONER_NAME=$provisioner
	else
		echo >&2 "No CA_PROVISIONER_NAME provided and no ACME provisioners found; certificate management is disabled."
		exit 1
	fi
fi

echo >&2 "Using CA provisioner: ${CA_PROVISIONER_NAME}."
step ca certificate $TLS_SUBJECT $TLS_CERT_LOCATION $TLS_KEY_LOCATION --provisioner ${CA_PROVISIONER_NAME}

chown redis:redis $TLS_CERT_LOCATION $TLS_KEY_LOCATION
