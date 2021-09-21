## Redis TLS automatic cert management Docker image

Redis with [step](https://github.com/smallstep/cli) + baked-in CA certificate + ACME enrollment + [step-ca](https://github.com/smallstep/certificates) renewal + hot reloading of Redis server certificate on renewal

### Build it:

Your CA certificate will be baked into the image.

```bash
docker build . --build-arg "CA_FINGERPRINT=c8de28e...620ecaa" \
        --build-arg "CA_URL=https://ca:4443/"
```

### Run it:

```bash
docker run -p 6379:6379 -p 80:80 -e TLS_SUBJECT=example.com fe5fc96 \
             --port 0 --tls-port 6379 \
             --tls-cert-file /run/tls/server.crt \
             --tls-key-file /run/tls/server.key \
             --tls-ca-cert-file /.step/certs/root_ca.crt \
             --tls-auth-clients no
```
