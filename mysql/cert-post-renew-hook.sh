#!/bin/bash

if [ -f "/run/secrets/root@localhost.cnf" ]; then
	gosu mysql mysql -A -uroot --defaults-extra-file="/run/secrets/root@localhost.cnf" -e "ALTER INSTANCE RELOAD TLS"
else
	gosu mysql mysql -A -uroot -p"$MYSQL_ROOT_PASSWORD" -e "ALTER INSTANCE RELOAD TLS"
fi
