import os
from pathlib import Path
from dotenv import load_dotenv
from sqlalchemy import create_engine, text
from sqlalchemy.engine import URL
from sqlalchemy.orm import sessionmaker

# Load .env
load_dotenv("/app/.env")

# Build SQLAlchemy DB URL
DB_PATH = URL.create(
    "mssql+pyodbc",
    username=os.getenv("USER_NAME"),
    password=os.getenv("PASSWORD"),
    host=os.getenv("SERVER"),
    database=os.getenv("DB"),
    query={
        "driver": "ODBC Driver 18 for SQL Server",
        "TrustServerCertificate": "yes",
        "Encrypt": "yes"
    }
)

# SQLAlchemy engine and session
engine = create_engine(DB_PATH, fast_executemany=True)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def get_data_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# If init.sql exists, run it
SQL_FILE = Path("/app/init.sql")
if SQL_FILE.exists():
    with SQL_FILE.open() as f:
        sql = f.read()

    with engine.connect() as conn:
        for stmt in [s.strip() for s in sql.split(";") if s.strip()]:
            conn.execute(text(stmt))
        conn.commit()

# Keep container running (or start your app here)
os.execvp("python", ["python"])
