FROM smallstep/step-cli as step
FROM rabbitmq
COPY --from=step /usr/local/bin/step /usr/local/bin/
ARG CA_URL
ARG CA_FINGERPRINT
ENV CA_URL=${CA_URL} CA_FINGERPRINT=${CA_FINGERPRINT} STEPPATH=/.step TLS_CERT_LOCATION=/run/tls/server.crt TLS_KEY_LOCATION=/run/tls/server.key
RUN step ca bootstrap --ca-url $CA_URL --fingerprint $CA_FINGERPRINT; \
	apt-get update; \
    apt-get install -y --no-install-recommends jq; \
    rm -rf /var/lib/apt/lists/*; \
    mkdir -p /run/tls; \
	cp /.step/certs/root_ca.crt /run/tls/ca.crt; \
    chown -R rabbitmq:rabbitmq /run/tls /.step

COPY rabbitmq-tls.conf /etc/rabbitmq/conf.d/20-tls.conf

COPY entrypoint-shim.sh /usr/local/bin/
COPY cert-*.sh /usr/local/bin/
ENTRYPOINT ["entrypoint-shim.sh"]
