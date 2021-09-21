# Redis TLS in docker with transparent certificate watch

This Docker image adds a certificate watch script that runs in the background.
When the server TLS certificate file changes on the filesystem,
it triggers a hot reload of the certificate in Redis.

Run it with a volume mount to a certificates folder, so that an external process
can renew your certificate files.

```
docker run -p 6379:6379 -v $PWD/certs:/run/secrets \
                   redis \
                   --port 0 --tls-port 6379 \
                   --tls-cert-file /run/secrets/server.crt \
                   --tls-key-file /run/secrets/server.key \
                   --tls-ca-cert-file /run/secrets/ca.crt \
                   --tls-auth-clients no
```

## Notes

* You will need to supply `REDIS_USERNAME` or `REDISCLI_AUTH` as environment variables if you are using
  password authentication, so that the watcher can connect to Redis and update the certificate.
