import os
from pathlib import Path
import pyodbc

CONN_STRING = os.getenv("CONNECTION_STRING") or os.getenv("PYODBC_CONN_STR") or os.getenv("ODBC_CONNECTION_STRING")
SQL_FILE = Path('/app/init.sql')

if CONN_STRING and SQL_FILE.exists():
    with SQL_FILE.open() as f:
        sql = f.read()
    conn = pyodbc.connect(CONN_STRING)
    cursor = conn.cursor()
    for stmt in [s.strip() for s in sql.split(';') if s.strip()]:
        cursor.execute(stmt)
    conn.commit()
    cursor.close()
    conn.close()

os.execvp('python', ['python'])
