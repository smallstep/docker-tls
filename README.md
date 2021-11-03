Here's a few Docker images that add full, self-contained TLS certificate management to common Docker services:
- [MongoDB](https://github.com/smallstep/docker-tls/tree/main/mongodb)
- [Nginx Unit](https://github.com/smallstep/docker-tls/tree/main/nginx-unit)
- [Redis](https://github.com/smallstep/docker-tls/tree/main/redis)
- [PostgreSQL](https://github.com/smallstep/docker-tls/tree/main/postgres)
- [TimescaleDB](https://github.com/smallstep/docker-tls/tree/main/timescaledb)
- [MySQL](https://github.com/smallstep/docker-tls/tree/main/mysql)
- [MariaDB](https://github.com/smallstep/docker-tls/tree/main/mariadb)
- [RabbitMQ](https://github.com/smallstep/docker-tls/tree/main/rabbitmq)

All of these examples use the [`step-ca`](https://github.com/smallstep/certificates/) Certificate Authority server and the [`step`](https://github.com/smallstep/cli/) CLI tool for TLS certificate management. If you don't want to run your own CA, try our [Certificate Manager](https://smallstep.com/signup?product=cm) hosted CA to get going quickly. You'll need a CA url and root fingerprint to build these images.

See [our blog post on TLS in Docker](https://smallstep.com/blog/automate-docker-ssl-tls-certificates/) for more context.
