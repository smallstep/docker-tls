FROM smallstep/step-cli as step
FROM mongo
# https://github.com/docker-library/mongo/blob/master/Dockerfile-linux.template
# mongo image comes with jq installed
COPY --from=step /usr/local/bin/step /usr/local/bin/
ARG CA_URL
ARG CA_FINGERPRINT
ENV CA_URL=${CA_URL} CA_FINGERPRINT=${CA_FINGERPRINT} STEPPATH=/.step TLS_PEM_LOCATION=/run/tls/server.pem TLS_CERT_LOCATION=/run/tls/server.crt TLS_KEY_LOCATION=/run/tls/server.key TLS_CA_CERT_LOCATION=/run/tls/ca.crt
RUN step ca bootstrap --ca-url $CA_URL --fingerprint $CA_FINGERPRINT --install
RUN mkdir -p /run/tls; \
    chown -R mongodb:mongodb /run/tls /.step

COPY entrypoint-shim.sh cert-*.sh /usr/local/bin/
ENTRYPOINT ["entrypoint-shim.sh"]
