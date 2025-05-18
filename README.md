# Python + SQL Server Dev Container (ODBC 18)

This project provides a Dockerized Python development environment with Microsoft ODBC Driver 18 for SQL Server pre-installed and dynamically configured with a DSN at runtime.

Ideal for testing database connectivity, running queries, or bootstrapping SQL-related Python projects.

---

## Features

- Python 3.12 (based on `python:3.12-slim-bookworm`)
- Microsoft ODBC Driver 18 for SQL Server
- DSN dynamically generated at container start
- Sample entrypoint script (`entrypoint.py`) for DB initialization
- Optional `init.sql` support to auto-run queries at launch
- `.env` file support for runtime configuration

---

## Getting Started

### 1. Clone the repo

```bash
git clone https://github.com/YOUR_USERNAME/python-sql-odbc-dev-container.git
cd python-sql-odbc-dev-container
```

### 2. Build the Docker image

```bash
docker build -t python-sql-dev .
```

### 3. Create a `.env` file

```env
ODBC_DSN=mydsn
DB_SERVER=your_sql_server_ip or localhost (if running in container with 1433 exposed)
DB_DATABASE=your_database_name
DB_USER=your_user
DB_PASSWORD=your_pass
```

### 4. (Optional) Add an `init.sql` script

Place a file named `init.sql` in the project root if you want to initialize the database (e.g., create tables, seed data).

### 5. Run the container

```bash
docker run --rm --env-file .env python-sql-dev
```

> The container will auto-generate the DSN from your environment variables and optionally execute `init.sql` at startup.

---

## Configuration

The following environment variables are required at runtime:

| Variable             | Description                                |
|----------------------|--------------------------------------------|
| `ODBC_DSN`           | Name of the ODBC DSN (used in Python)      |
| `DB_SERVER`          | SQL Server hostname or IP                  |
| `DB_DATABASE`        | Target database name                       |
| `DB_USER`            | SQL username (optional for trusted auth)   |
| `DB_PASSWORD`        | SQL password (optional for trusted auth)   |
| `CONNECTION_STRING`  | (Optional) full override connection string |

The DSN is dynamically created inside `/etc/odbc.ini` based on the above.

---

## Sample Code

The `.py` script will auto-run at container start and apply any SQL from `init.sql` using the best available connection string:

```python
import pyodbc
import os

dsn = os.getenv("ODBC_DSN")
conn_str = f"DSN={dsn};Trusted_Connection=yes"
conn = pyodbc.connect(conn_str)
cursor = conn.cursor()
cursor.execute("SELECT GETDATE()")
print(cursor.fetchone())
```

---

## TODO

- Add support for connection encryption and trust cert options
- Add `devcontainer.json` for VS Code remote development
- Add support for Docker volumes for persistent SQL scripts

---

## License

MIT
