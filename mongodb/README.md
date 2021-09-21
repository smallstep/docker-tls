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
docker run -it -e TLS_SUBJECT=mongo.example.com -p 80:80 -p 27017:27017 $(docker images -q | head -1) \
	--tlsMode requireTLS \
	--tlsCAFile /run/tls/ca.crt \
	--tlsCertificateKeyFile /run/tls/server.pem
```

