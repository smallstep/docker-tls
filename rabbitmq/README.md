## RabbitMQ TLS automatic cert management Docker image

RabbitMQ with [step](https://github.com/smallstep/cli) + baked-in CA certificate + ACME or JWK enrollment + [step-ca](https://github.com/smallstep/certificates) renewal + hot reloading of RabbitMQ server certificate on renewal

### Build it:

Your CA certificate will be baked into the image.

```bash
docker build . --build-arg "CA_FINGERPRINT=c8de28e...620ecaa" \
        --build-arg "CA_URL=https://ca:4443/"
```

### Testing with a 5 minute cert:

```bash
docker run -it --rm -p 5671:5671 -p 80:80 --name rabbitmq \
           -e TLS_DOMAINS=rabbitmq.example.com,mqtt.example.com
           -e STEP_NOT_AFTER=5m \
           (docker images -q | head -1) rabbitmq-server
```

