#!/bin/bash
set -e
host="$1"
shift
cmd="$@"
until mysql -hmysql -p"3306" -u"${database__connection__user}" -p"${database__connection__password}" 
-D"${database__connection__database}" ; do
  >&2 echo "MySQL is unavailable, waiting for it to start"
  sleep 10
done
>&2 echo "MySQL is up - executing command"
exec "$@"