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

### ACME enrollment

Port 80 will need to be exposed in order to do enrollment with an `HTTP-01` ACME challenge via the default bridge network. You could alternatively expose port 80 to a different host port, and run a reverse proxy to pass ACME challenges from the `/.well-known/acme-challenge/<TOKEN>` endpoint into the container. Or, for TLS certificates that will be used for internal traffic within a bridge or overlay network, you could run a CA or RA server within your container environment that offers ACME.

### JWK enrollment

To enroll the container using a JWK CA provisioner, pass a `CA_TOKEN` into the container:

```bash
docker run -d --name rabbitmq \
    -e TLS_DOMAINS=mysql.example.com,db.example.com \
    -e CA_TOKEN=$(step ca token rabbitmq.example.com --san rabbitmq.example.com --san mqtt.example.com) \
    -p 3306:3306 \
    (docker images -q | head -1) rabbitmq-server
```


