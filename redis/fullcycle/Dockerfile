FROM smallstep/step-cli as step
FROM redis
COPY --from=step /usr/local/bin/step /usr/local/bin/
ARG CA_URL
ARG CA_FINGERPRINT
ENV CA_URL=${CA_URL} CA_FINGERPRINT=${CA_FINGERPRINT} STEPPATH=/.step
RUN step ca bootstrap --ca-url $CA_URL --fingerprint $CA_FINGERPRINT
RUN apt-get update; \
    apt-get install -y --no-install-recommends jq; \
    rm -rf /var/lib/apt/lists/*; \
    mkdir -p /run/secrets; \
    chown -R redis:redis /run/secrets /.step

COPY docker-entrypoint.sh /usr/local/bin/
COPY cert-enroller.sh /
COPY cert-renewer.sh /
COPY cert-reloader.sh /
ENTRYPOINT ["docker-entrypoint.sh"]
