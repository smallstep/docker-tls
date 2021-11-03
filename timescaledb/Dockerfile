FROM smallstep/step-cli as step
FROM timescale/timescaledb:latest-pg12
# Upstream Dockerfile: https://github.com/timescale/timescaledb-docker/blob/master/Dockerfile

COPY --from=step /usr/local/bin/step /usr/local/bin/
ARG CA_URL
ARG CA_FINGERPRINT
ENV CA_URL=${CA_URL} CA_FINGERPRINT=${CA_FINGERPRINT} STEPPATH=/.step TLS_CERT_LOCATION=/run/tls/server.crt TLS_KEY_LOCATION=/run/tls/server.key TLS_CA_CERT_LOCATION=/run/tls/ca.crt
RUN step ca bootstrap --ca-url $CA_URL --fingerprint $CA_FINGERPRINT; \
    apk update; \
    apk add --no-cache su-exec jq; \
    mkdir -p /run/tls; \
    cp /.step/certs/root_ca.crt /run/tls/ca.crt

COPY entrypoint-shim.sh cert-*.sh /usr/local/bin/
ENTRYPOINT ["entrypoint-shim.sh"]
