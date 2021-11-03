#!/bin/bash

if [ -f "/run/secrets/reloader@localhost.cnf" ]; then
	gosu mysql mysql -A --defaults-extra-file="/run/secrets/reloader@localhost.cnf" -e "FLUSH SSL"
else
	gosu mysql mysql -A -uroot -p"$MYSQL_ROOT_PASSWORD" -e "FLUSH SSL"
fi
