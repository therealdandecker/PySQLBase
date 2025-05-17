#!/bin/bash

if [[ -n "$ODBC_DSN" && -n "$DB_SERVER" && -n "$DB_DATABASE" ]]; then
  cat <<EOF > /etc/odbc.ini
[${ODBC_DSN}]
Driver = ODBC Driver 18 for SQL Server
Server = ${DB_SERVER}
Database = ${DB_DATABASE}
EOF
fi

exec python /app/entrypoint.py
