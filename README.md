# Python + SQL Server Dev Container (ODBC 18)

This project provides a Dockerized Python development environment with Microsoft ODBC Driver 18 for SQL Server pre-installed and pre-configured with a development DSN.

Ideal for testing database connectivity, running queries, or bootstrapping SQL-related Python projects.

---
- Python 3.12 (based on `python:3.12-slim-bookworm`)
- Microsoft ODBC Driver 18 for SQL Server
- Preconfigured DSN named `el2`
- Sample entrypoint script (`entrypoint.py`) for DB connectivity
- Simple `requirements.txt` support
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

### 3. Run the container

```bash
docker run --rm -it python-sql-dev
```

> The container runs `entrypoint.py` on startup by default if you have an init.sql query in the main project folder.  This is to create a database, tables etc. as needed.

---

## 🔧 Configuration

Environment variables used in the image:

| Variable             | Description                         |
|----------------------|-------------------------------------|
| `ODBC_DSN`           | Name of the ODBC DSN                |
| `DB_SERVER`          | SQL Server address                  |
| `DB_DATABASE`        | Target database                     |

The DSN will be the name of the environment variable you set, and will be pre-configured in `/etc/odbc.ini`.

---

## 🧪 Sample Code

The default `entrypoint.py` connects using ODBC and prints a result:

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

- Parameterize DSN config more cleanly
- Add secrets support for DB credentials
- Optional: Use `devcontainer.json` for VS Code integration

---

## 📄 License

MIT
