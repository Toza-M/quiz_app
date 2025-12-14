from flask import Blueprint, request, jsonify, current_app
import os
import pymysql
import uuid
import datetime
import jwt
import bcrypt

auth = Blueprint('auth', __name__, url_prefix='/auth')


def get_db_connection():
    host = os.environ.get('DB_HOST', 'localhost')
    user = os.environ.get('DB_USER', 'root')
    password = os.environ.get('DB_PASSWORD', '')
    db = os.environ.get('DB_NAME', 'quiz_app')
    port = int(os.environ.get('DB_PORT', 3306))

    conn = pymysql.connect(host=host, user=user, password=password, database=db, port=port,
                           cursorclass=pymysql.cursors.DictCursor, autocommit=True)
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
    created_at = int(datetime.datetime.utcnow().timestamp())

    try:
        conn = get_db_connection()
        with conn.cursor() as cur:
            cur.execute('SELECT id FROM users WHERE email = %s', (email,))
            if cur.fetchone():
                return jsonify({'error': 'email already exists'}), 409

            cur.execute(
                '''INSERT INTO users (id, email, password_hash, full_name, created_at)
                   VALUES (%s, %s, %s, %s, %s)''',
                (user_id, email, pw_hash.decode('utf-8'), full_name, created_at)
            )

        token = create_jwt({'user_id': user_id, 'email': email})
        return jsonify({'message': 'user registered', 'token': token}), 201

    except Exception as e:
        current_app.logger.exception('DB error')
        return jsonify({'error': 'internal server error', 'details': str(e)}), 500
    finally:
        try:
            conn.close()
        except Exception:
            pass


@auth.route('/login', methods=['POST'])
def login():
    data = request.get_json() or {}
    email = (data.get('email') or '').lower()
    password = data.get('password')

    if not email or not password:
        return jsonify({'error': 'email and password are required'}), 400

    try:
        conn = get_db_connection()
        with conn.cursor() as cur:
            cur.execute('SELECT id, email, password_hash, full_name FROM users WHERE email = %s', (email,))
            row = cur.fetchone()
            if not row:
                return jsonify({'error': 'invalid credentials'}), 401

            stored = row.get('password_hash') or ''
            try:
                ok = bcrypt.checkpw(password.encode('utf-8'), stored.encode('utf-8'))
            except Exception:
                ok = False

            if not ok:
                return jsonify({'error': 'invalid credentials'}), 401

            token = create_jwt({'user_id': row['id'], 'email': row['email']})
            return jsonify({'message': 'login successful', 'token': token, 'user': {'id': row['id'], 'email': row['email'], 'full_name': row.get('full_name')}}), 200

    except Exception as e:
        current_app.logger.exception('DB error')
        return jsonify({'error': 'internal server error', 'details': str(e)}), 500
    finally:
        try:
            conn.close()
        except Exception:
            pass


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
        with conn.cursor() as cur:
            cur.execute('SELECT id, email, full_name, created_at FROM users WHERE id = %s', (user_id,))
            row = cur.fetchone()
            if not row:
                return jsonify({'error': 'user not found'}), 404

            return jsonify({'user': row}), 200
    except Exception as e:
        current_app.logger.exception('DB error')
        return jsonify({'error': 'internal server error', 'details': str(e)}), 500
    finally:
        try:
            conn.close()
        except Exception:
            pass
