from flask import Blueprint, request, jsonify, current_app
import sqlite3
import os
import uuid
import datetime
import jwt
import bcrypt

auth = Blueprint('auth', __name__, url_prefix='/auth')

DB_FILE = 'quiz_app.db'

def get_db_connection():
    conn = sqlite3.connect(DB_FILE)
    conn.row_factory = sqlite3.Row  # This allows accessing columns by name (row['email'])
    return conn

def create_jwt(payload: dict) -> str:
    secret = os.environ.get('JWT_SECRET', 'change-this-secret')
    exp = datetime.datetime.utcnow() + datetime.timedelta(hours=24)
    payload_copy = payload.copy()
    payload_copy['exp'] = exp
    token = jwt.encode(payload_copy, secret, algorithm='HS256')
    if isinstance(token, bytes):
        token = token.decode('utf-8')
    return token

def decode_jwt(token: str):
    secret = os.environ.get('JWT_SECRET', 'change-this-secret')
    try:
        data = jwt.decode(token, secret, algorithms=['HS256'])
        return data
    except jwt.ExpiredSignatureError:
        return None
    except Exception:
        return None

@auth.route('/register', methods=['POST'])
def register():
    data = request.get_json() or {}
    full_name = data.get('full_name')
    email = (data.get('email') or '').lower()
    password = data.get('password')

    if not full_name or not email or not password:
        return jsonify({'error': 'full_name, email and password are required'}), 400

    pw_hash = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())
    user_id = str(uuid.uuid4())

    try:
        conn = get_db_connection()
        cur = conn.cursor()
        
        # Check if user already exists
        cur.execute('SELECT id FROM users WHERE email = ?', (email,))
        if cur.fetchone():
            conn.close()
            return jsonify({'error': 'email already exists'}), 409

        # Insert new user
        cur.execute(
            '''INSERT INTO users (id, email, password_hash, full_name)
               VALUES (?, ?, ?, ?)''',
            (user_id, email, pw_hash.decode('utf-8'), full_name)
        )
        
        # IMPORTANT: SQLite requires explicit commit to save changes
        conn.commit()

        # Fetch the created row to return
        cur.execute('SELECT id, email, full_name, created_at FROM users WHERE id = ?', (user_id,))
        created = dict(cur.fetchone()) # Convert Row object to dict
        
        conn.close()

        token = create_jwt({'user_id': user_id, 'email': email})
        return jsonify({'message': 'user registered', 'token': token, 'user': created}), 201

    except Exception as e:
        current_app.logger.exception('DB error')
        return jsonify({'error': 'internal server error', 'details': str(e)}), 500

@auth.route('/login', methods=['POST'])
def login():
    data = request.get_json() or {}
    email = (data.get('email') or '').lower()
    password = data.get('password')

    if not email or not password:
        return jsonify({'error': 'email and password are required'}), 400

    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute('SELECT id, email, password_hash, full_name FROM users WHERE email = ?', (email,))
        row = cur.fetchone()
        conn.close()

        if not row:
            return jsonify({'error': 'invalid credentials'}), 401

        # sqlite3.Row acts like a dict but we need to be careful accessing it
        stored = row['password_hash']
        # Depending on how it was stored, it might be bytes or string
        if isinstance(stored, str):
            stored = stored.encode('utf-8')

        try:
            ok = bcrypt.checkpw(password.encode('utf-8'), stored)
        except Exception:
            ok = False

        if not ok:
            return jsonify({'error': 'invalid credentials'}), 401

        token = create_jwt({'user_id': row['id'], 'email': row['email']})
        return jsonify({
            'message': 'login successful', 
            'token': token, 
            'user': {
                'id': row['id'], 
                'email': row['email'], 
                'full_name': row['full_name']
            }
        }), 200

    except Exception as e:
        current_app.logger.exception('DB error')
        return jsonify({'error': 'internal server error', 'details': str(e)}), 500

@auth.route('/me', methods=['GET'])
def me():
    auth_header = request.headers.get('Authorization', '')
    if not auth_header.startswith('Bearer '):
        return jsonify({'error': 'authorization required'}), 401

    token = auth_header.split(' ', 1)[1]
    data = decode_jwt(token)
    if not data:
        return jsonify({'error': 'invalid or expired token'}), 401

    user_id = data.get('user_id')
    if not user_id:
        return jsonify({'error': 'invalid token payload'}), 401

    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute('SELECT id, email, full_name, created_at FROM users WHERE id = ?', (user_id,))
        row = cur.fetchone()
        conn.close()

        if not row:
            return jsonify({'error': 'user not found'}), 404

        # Convert Row to dict for JSON serialization
        return jsonify({'user': dict(row)}), 200
    except Exception as e:
        current_app.logger.exception('DB error')
        return jsonify({'error': 'internal server error', 'details': str(e)}), 500