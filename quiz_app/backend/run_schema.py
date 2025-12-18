import sqlite3
import os

DB_FILE = 'quiz_app.db'

def init_db():
    if os.path.exists(DB_FILE):
        print(f"Database {DB_FILE} already exists.")
        # Optional: Uncomment the next line if you want to wipe the data and start fresh
        # os.remove(DB_FILE) 
    
    conn = sqlite3.connect(DB_FILE)
    
    with open('schema.sql') as f:
        conn.executescript(f.read())
    
    conn.commit()
    conn.close()
    print("Schema initialized successfully in 'quiz_app.db'.")

if __name__ == '__main__':
    init_db()