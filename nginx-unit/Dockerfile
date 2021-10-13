FROM smallstep/step-cli as step
FROM nginx/unit:1.25.0-python3.9
# nginx-unit container setup
COPY config.json /docker-entrypoint.d/
COPY requirements.txt /config/requirements.txt
RUN apt update && apt install -y python3-pip                                  \
    && pip3 install -r /config/requirements.txt                               \
    && apt remove -y python3-pip                                              \
    && apt autoremove --purge -y                                              \
    && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/*.list

# certificate management
COPY --from=step /usr/local/bin/step /usr/local/bin/
ARG CA_URL
ARG CA_FINGERPRINT
ENV CA_URL=${CA_URL} CA_FINGERPRINT=${CA_FINGERPRINT} STEPPATH=/.step TLS_PEM_LOCATION=/docker-entrypoint.d/bundle.pem TLS_CERT_LOCATION=/run/tls/server.crt TLS_KEY_LOCATION=/run/tls/server.key TLS_CA_CERT_LOCATION=/run/tls/ca.crt
RUN step ca bootstrap --ca-url $CA_URL --fingerprint $CA_FINGERPRINT --install; \
    apt-get update; \
    apt-get install -y --no-install-recommends jq; \
    rm -rf /var/lib/apt/lists/*; \
    mkdir -p /run/tls; \
    cp /.step/certs/root_ca.crt /run/tls/ca.crt

COPY entrypoint-shim.sh cert-*.sh /usr/local/bin/
ENTRYPOINT ["entrypoint-shim.sh"]
