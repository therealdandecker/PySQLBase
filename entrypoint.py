import os
from pathlib import Path
import pyodbc
from dotenv import load_dotenv

load_dotenv()
CONN_STRING = (
    os.getenv("CONNECTION_STRING")
    or os.getenv("PYODBC_CONN_STR")
    or os.getenv("ODBC_CONNECTION_STRING")
)

if not CONN_STRING:
    dsn = os.getenv("ODBC_DSN")
    server = os.getenv("DB_SERVER")
    database = os.getenv("DB_DATABASE")
    user = os.getenv("DB_USER")
    password = os.getenv("DB_PASSWORD")

    if dsn:
        parts = [f"DSN={dsn}"]
        if user:
            parts.append(f"UID={user}")
        if password:
            parts.append(f"PWD={password}")
        CONN_STRING = ";".join(parts)
    elif server and database:
        parts = [
            "DRIVER={ODBC Driver 18 for SQL Server}",
            f"SERVER={server}",
            f"DATABASE={database}",
        ]
        if user:
            parts.append(f"UID={user}")
        if password:
            parts.append(f"PWD={password}")
        CONN_STRING = ";".join(parts)

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
