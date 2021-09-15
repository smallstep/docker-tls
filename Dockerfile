FROM redis
RUN apt-get update; \
    apt-get install -y --no-install-recommends inotify-tools; \
    rm -rf /var/lib/apt/lists/*

COPY docker-entrypoint.sh /usr/local/bin/
COPY certwatch.sh /
ENTRYPOINT ["docker-entrypoint.sh"]
