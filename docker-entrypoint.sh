#!/bin/bash
set -e
MYSQLDATA=/db
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:mysql4}



if [ "$1" = 'mysqld_safe' ]; then
    chown -R mysql "$MYSQLDATA"
    if [ -z "$(ls -A "$MYSQLDATA")" ]; then
        echo "Initializing database..."
        mysql_install_db --user=mysql

        "$@" --skip-networking &
        pid="$!"

        for i in {30..0}; do
            if echo 'SELECT 1' | mysql &> /dev/null; then
              break
            fi
            echo 'MySQL init process in progress...'
            sleep 1
        done
        if [ "$i" = 0 ]; then
            echo >&2 'MySQL init process failed.'
            exit 1
        fi

if [ ! -z "$MYSQL_ALLOW_EMPTY_PASSWORD" ]; then
mysql <<-EOSQL
    SET @@SESSION.SQL_LOG_BIN=0;
    GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    FLUSH PRIVILEGES;
EOSQL
        fi

        mysqladmin shutdown

        if ! wait $pid; then
            echo >&2 'MySQL init process failed.'
            exit 1
		fi
    fi
fi

exec "$@"
