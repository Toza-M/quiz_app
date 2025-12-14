"""Run the SQL schema against a MySQL server using environment variables.

Requires: PyMySQL and python-dotenv (optional)
"""
import os
from pathlib import Path

try:
    from dotenv import load_dotenv
    load_dotenv(Path(__file__).parent / '.env')
except Exception:
    pass

import pymysql

SQL_FILE = Path(__file__).parent / 'schema.sql'

host = os.environ.get('DB_HOST', 'localhost')
port = int(os.environ.get('DB_PORT', '3306'))
user = os.environ.get('DB_USER', 'root')
password = os.environ.get('DB_PASSWORD', '')

if not SQL_FILE.exists():
    print('schema.sql not found:', SQL_FILE)
    raise SystemExit(1)

sql = SQL_FILE.read_text()

# Connect to server (no initial database to allow CREATE DATABASE)
conn = pymysql.connect(host=host, user=user, password=password, port=port, autocommit=True)
try:
    with conn.cursor() as cur:
        for stmt in sql.split(';'):
            s = stmt.strip()
            if not s:
                continue
            print('Executing statement:')
            print(s[:200])
            cur.execute(s)
    print('Schema applied successfully')
finally:
    conn.close()
