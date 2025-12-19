import sqlite3
import os
from flask import Blueprint, request, jsonify
from werkzeug.security import generate_password_hash, check_password_hash

auth = Blueprint('auth', __name__)

class DatabaseManager:
    _instance = None
    _connection = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(DatabaseManager, cls).__new__(cls)
            # Use absolute path to the DB file
            db_path = os.path.join(os.path.dirname(__file__), 'quiz_app.db')
            # check_same_thread=False is needed for SQLite in Flask
            cls._connection = sqlite3.connect(db_path, check_same_thread=False)
            cls._connection.row_factory = sqlite3.Row
            cls._instance._init_db()
        return cls._instance

    def _init_db(self):
        """Initializes the schema inside the Singleton constructor."""
        self._connection.execute('''
            CREATE TABLE IF NOT EXISTS users (
                id INTEGER PRIMARY KEY AUTOINCREMENT, 
                username TEXT NOT NULL, 
                email TEXT UNIQUE NOT NULL, 
                password TEXT NOT NULL
            )
        ''')
        self._connection.commit()

    def get_conn(self):
        return self._connection

# Global access point for the Singleton
db_manager = DatabaseManager()

@auth.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    username = data.get('username')
    email = data.get('email')
    
    if not data.get('password'):
        return jsonify({"error": "Password is required"}), 400
    
    password_hash = generate_password_hash(data.get('password'))
    conn = db_manager.get_conn()

    try:
        conn.execute('INSERT INTO users (username, email, password) VALUES (?, ?, ?)',
                     (username, email, password_hash))
        conn.commit()
        return jsonify({"message": "User registered successfully"}), 201
    except sqlite3.IntegrityError:
        return jsonify({"error": "Email already exists"}), 400

@auth.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')

    conn = db_manager.get_conn()
    user = conn.execute('SELECT * FROM users WHERE email = ?', (email,)).fetchone()
    
    if user and check_password_hash(user['password'], password):
        return jsonify({
            "message": "Login successful",
            "user": {"id": user['id'], "username": user['username'], "email": user['email']}
        }), 200
    
    return jsonify({"error": "Invalid email or password"}), 401