import sqlite3
from flask import Blueprint, request, jsonify
from werkzeug.security import generate_password_hash, check_password_hash

auth = Blueprint('auth', __name__)
DATABASE = 'quiz_app.db'

def get_db_connection():
    conn = sqlite3.connect(DATABASE)
    conn.row_factory = sqlite3.Row
    return conn

# Create the users table if it doesn't exist
def init_db():
    conn = get_db_connection()
    conn.execute('''CREATE TABLE IF NOT EXISTS users 
                    (id INTEGER PRIMARY KEY AUTOINCREMENT, 
                     username TEXT NOT NULL, 
                     email TEXT UNIQUE NOT NULL, 
                     password TEXT NOT NULL)''')
    conn.commit()
    conn.close()

init_db()

@auth.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    username = data.get('username')
    email = data.get('email')
    password = generate_password_hash(data.get('password'))

    try:
        conn = get_db_connection()
        conn.execute('INSERT INTO users (username, email, password) VALUES (?, ?, ?)',
                     (username, email, password))
        conn.commit()
        conn.close()
        return jsonify({"message": "User registered successfully"}), 201
    except sqlite3.IntegrityError:
        return jsonify({"error": "Email already exists"}), 400

@auth.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')

    conn = get_db_connection()
    user = conn.execute('SELECT * FROM users WHERE email = ?', (email,)).fetchone()
    conn.close()

    if user and check_password_hash(user['password'], password):
        # In a real app, you would return a JWT token here
        return jsonify({
            "message": "Login successful",
            "user": {"id": user['id'], "username": user['username'], "email": user['email']}
        }), 200
    else:
        return jsonify({"error": "Invalid email or password"}), 401