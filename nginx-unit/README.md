## Nginx Unit TLS automatic cert management Docker image

Nginx Unit with [step](https://github.com/smallstep/cli) + baked-in CA certificate + ACME or JWK enrollment + [step-ca](https://github.com/smallstep/certificates) renewal + hot reloading of certificate on renewal

### Build it:

Your CA certificate will be baked into the image.

```bash
docker build . --build-arg "CA_FINGERPRINT=c8de28e...620ecaa" \
        --build-arg "CA_URL=https://ca:4443/"
```

## Test it with a 5 minute certificate:

```bash
docker run -e TLS_DOMAINS=www.example.com \
       -p 80:80 -p 443:443 \
	   -e STEP_NOT_AFTER=5m \
	   --mount type=bind,src="$(pwd)/webapp",dst=/www \
	   $(docker images -q | head -1) \
	   unitd --no-daemon --control unix:/var/run/control.unit.sock
```

Notice the use of `STEP_NOT_AFTER`. You can use `STEP_` environment variables to pass optional flags to the [`step ca certificate`](https://smallstep.com/docs/step-cli/reference/ca/certificate) command.

### ACME enrollment

Port 80 will need to be exposed in order to do enrollment with an `HTTP-01` ACME challenge via the default bridge network. You could alternatively expose port 80 to a different host port, and run a reverse proxy to pass ACME challenges from the `/.well-known/acme-challenge/<TOKEN>` endpoint into the container. Or, for TLS certificates that will be used for  interal traffic within a bridge or overlay network, you could run a CA or RA server within your container environment that offers ACME.

### JWK enrollment

To enroll the container using a JWK CA provisioner, pass a `CA_TOKEN` into the container:

```bash
docker run -it -e TLS_DOMAINS=mongo.example.com,db.example.com \
	-e CA_TOKEN=$(step ca token mongodb.example.com --san mongodb.example.com --san db.example.com)
    -p 80:80 -p 443:443 \
	-e STEP_NOT_AFTER=5m \
	--mount type=bind,src="$(pwd)/webapp",dst=/www \
	$(docker images -q | head -1) \
	unitd --no-daemon --control unix:/var/run/control.unit.sock
```

