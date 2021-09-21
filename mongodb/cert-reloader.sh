#!/bin/sh

cat $TLS_CERT_LOCATION $TLS_KEY_LOCATION > $TLS_PEM_LOCATION
mongosh --tlsAllowInvalidCertificates \
     "mongodb://localhost:27017?tls=true&tlsCAFile=${TLS_CA_CERT_LOCATION}&tlsCertificateKeyFile=${TLS_PEM_LOCATION}" \
     -f <(echo "db.adminCommand( { rotateCertificates: 1 } )")
