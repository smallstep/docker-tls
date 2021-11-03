## MariaDB TLS automatic cert management Docker image

A MariaDB image with [step](https://github.com/smallstep/cli) + baked-in CA certificate + ACME or JWK enrollment + [step-ca](https://github.com/smallstep/certificates) renewal + hot reloading of MariaDB certificates on renewal

MariaDB supports hot reloading of certificates starting in version 10.4.

### Build it:

Your CA certificate will be baked into the image.

```bash
docker build . --build-arg "CA_FINGERPRINT=c8de28e...620ecaa" \
        --build-arg "CA_URL=https://ca:4443/"
```

## Test it with a 5 minute certificate:

```bash
docker run -it --rm \
	-e MYSQL_ROOT_PASSWORD=my-secret-pw \
    -e TLS_DOMAINS=mariadb.example.com,db.example.com \
	-e STEP_NOT_AFTER=5m \
	-p 80:80 -p 3306:3306 \
    $(docker images -q | head -1) \
    --require-secure-transport=ON \
    --ssl-cert=/run/tls/server.crt \
    --ssl-key=/run/tls/server.key \
    --ssl-ca=/run/tls/ca.crt \
    --tls-version=TLSv1.2,TLSv1.3
```

Notice the use of `STEP_NOT_AFTER`. You can use `STEP_` environment variables to pass optional flags to the [`step ca certificate`](https://smallstep.com/docs/step-cli/reference/ca/certificate) command.

### ACME enrollment

Port 80 will need to be exposed in order to do enrollment with an `HTTP-01` ACME challenge via the default bridge network. You could alternatively expose port 80 to a different host port, and run a reverse proxy to pass ACME challenges from the `/.well-known/acme-challenge/<TOKEN>` endpoint into the container. Or, for TLS certificates that will be used for  interal traffic within a bridge or overlay network, you could run a CA or RA server within your container environment that offers ACME.

### JWK enrollment

To enroll the container using a JWK CA provisioner, pass a `CA_TOKEN` into the container:

```bash
docker run -it -e MYSQL_ROOT_PASSWORD=my-secret-pw \
    -e TLS_DOMAINS=mariadb.example.com,db.example.com \
	-e CA_TOKEN=$(step ca token mariadb.example.com --san mariadb.example.com --san db.example.com)
	-p 3306:3306 \
	$(docker images -q | head -1) \
    --require-secure-transport=ON \
    --ssl-cert=/run/tls/server.crt \
    --ssl-key=/run/tls/server.key \
    --ssl-ca=/run/tls/ca.crt \
    --tls-version=TLSv1.2,TLSv1.3
```

## Productionize it:

For production, create a `/run/secrets/root@localhost.cnf` [option file](https://mariadb.com/kb/en/configuring-mariadb-with-option-files/), which the renewal hook script will use to look up the password for connecting to the database as `root` and running `FLUSH SSL`. The option file will need to be owned by the `mariadb` user and have `600` permissions.

Also, use a `MYSQL_ROOT_PASSWORD_FILE` instead of a hardcoded password:

```bash
docker run -d -e MYSQL_ROOT_PASSWORD_FILE=/run/secrets/password-file \
    -e TLS_DOMAINS=mariadb.example.com,db.example.com \
	-p 80:80 -p 3306:3306 \
    $(docker images -q | head -1) \
    --require-secure-transport=ON \
    --ssl-cert=/run/tls/server.crt \
    --ssl-key=/run/tls/server.key \
    --ssl-ca=/run/tls/ca.crt \
    --tls-version=TLSv1.2,TLSv1.3
```

