#!/bin/bash

cat $TLS_CERT_LOCATION $TLS_KEY_LOCATION > $TLS_PEM_LOCATION

previous_bundle_id=$(curl -s -X GET --unix-socket /var/run/control.unit.sock \
	'http://localhost/config/listeners/*:443/tls/certificate' | jq -r)
new_bundle_id="bundle-$(md5sum $TLS_PEM_LOCATION | head -c32)"

curl -s -X PUT --data-binary @$TLS_PEM_LOCATION --unix-socket \
	/var/run/control.unit.sock "http://localhost/certificates/$new_bundle_id"
curl -s -X PUT --data-binary "\"$new_bundle_id\""  \
	      --unix-socket /var/run/control.unit.sock \
		  'http://localhost/config/listeners/*:443/tls/certificate'
curl -s -X DELETE --unix-socket /var/run/control.unit.sock \
	      "http://localhost/certificates/$previous_bundle_id"
