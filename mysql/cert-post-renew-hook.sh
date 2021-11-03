#!/bin/bash

if [ -f "/run/secrets/reloader@localhost.cnf" ]; then
	gosu mysql mysql -A --defaults-extra-file="/run/secrets/reloader@localhost.cnf" -e "ALTER INSTANCE RELOAD TLS"
else
	gosu mysql mysql -A -uroot -p"$MYSQL_ROOT_PASSWORD" -e "ALTER INSTANCE RELOAD TLS"
fi
