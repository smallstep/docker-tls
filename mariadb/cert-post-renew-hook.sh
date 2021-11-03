#!/bin/bash

if [ -f "/run/secrets/root@localhost.cnf" ]; then
	gosu mysql mysql -A -uroot --defaults-extra-file="/run/secrets/root@localhost.cnf" -e "FLUSH SSL"
else
	gosu mysql mysql -A -uroot -p"$MYSQL_ROOT_PASSWORD" -e "FLUSH SSL"
fi
