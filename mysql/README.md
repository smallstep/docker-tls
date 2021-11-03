## MySQL TLS automatic cert management Docker image

A MySQL image with [step](https://github.com/smallstep/cli) + baked-in CA certificate + ACME or JWK enrollment + [step-ca](https://github.com/smallstep/certificates) renewal + hot reloading of MySQL certificates on renewal

MySQL Community Server supports hot reloading of certificates as of [version 8.0.16](https://forums.mysql.com/read.php?3,674339,674339), via [`ALTER INSTANCE RELOAD TLS`](https://dev.mysql.com/doc/refman/8.0/en/alter-instance.html).

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
    -e TLS_DOMAINS=mysql.example.com,db.example.com \
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

When the container first starts, if there's no existing database in `/var/lib/mysql`, it will initialize one.
You'll see that it creates self-signed certificates as part of this process, but those will not be used.


### ACME enrollment

Port 80 will need to be exposed in order to do enrollment with an `HTTP-01` ACME challenge via the default bridge network. You could alternatively expose port 80 to a different host port, and run a reverse proxy to pass ACME challenges from the `/.well-known/acme-challenge/<TOKEN>` endpoint into the container. Or, for TLS certificates that will be used for  interal traffic within a bridge or overlay network, you could run a CA or RA server within your container environment that offers ACME.

### JWK enrollment

To enroll the container using a JWK CA provisioner, pass a `CA_TOKEN` into the container:

```bash
docker run -it -e MYSQL_ROOT_PASSWORD=my-secret-pw \
    -e TLS_DOMAINS=mysql.example.com,db.example.com \
	-e CA_TOKEN=$(step ca token mysql.example.com --san mysql.example.com --san db.example.com)
	-p 3306:3306 \
	$(docker images -q | head -1) \
    --require-secure-transport=ON \
    --ssl-cert=/run/tls/server.crt \
    --ssl-key=/run/tls/server.key \
    --ssl-ca=/run/tls/ca.crt \
    --tls-version=TLSv1.2,TLSv1.3
```

## Production Considerations

- Create a non-root database user to reload the certificates. That user will need the `CONNECTION_ADMIN` privilege.
- Create a special `/run/secrets/root@localhost.cnf` [option file](https://dev.mysql.com/doc/refman/8.0/en/option-files.html), which the renewal hook script will use to look up the credentials for connecting to the database and running [`ALTER INSTANCE RELOAD TLS`](https://dev.mysql.com/doc/refman/8.0/en/alter-instance.html). The option file will need to be owned by the `mysql` user and have `600` permissions.

  Here's an example `reloader@localhost.cnf`:

  ```ini
  [client]
  username="reloader"
  password="my-secret-pw"
  ```

