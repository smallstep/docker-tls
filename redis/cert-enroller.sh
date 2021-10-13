#!/bin/bash

count=0
declare -a tls_sans
for i in ${TLS_DOMAINS//,/ }
do
    if [ "$count" = "0" ]; then
		tls_subject=$i
	fi
	tls_sans=("${tls_sans[@]}" --san "$i")
	let "count++"
done
if [ "$count" = "0" ]; then
	echo >&2 "You must supply at least one value to \$TLS_DOMAINS"
	exit 1
fi 
if [ "$count" = "1" ]; then
	tls_sans=()
fi

declare -a flags
if [ -z "$CA_TOKEN" ]; then
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
	flags=("${flags[@]}" --provisioner ${CA_PROVISIONER_NAME})
else
	flags=("${flags[@]}" --token ${CA_TOKEN})
fi
flags=("${flags[@]}" "${tls_sans[@]}")


step ca certificate $tls_subject $TLS_CERT_LOCATION $TLS_KEY_LOCATION ${flags[@]}
/usr/local/bin/cert-post-enroll-hook.sh

