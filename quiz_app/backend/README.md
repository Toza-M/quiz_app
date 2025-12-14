# Quiz App Backend

This backend provides:
- `/generate` — file upload -> generate questions
- `/auth/*` — MySQL-backed auth endpoints (register, login, me)

Setup (MySQL)

1. Create database and run schema using `mysql` CLI:

```powershell
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS quiz_app CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -u root -p quiz_app < schema.sql
```

Or use the provided Python helper (requires `PyMySQL` and `python-dotenv`):

```powershell
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
python run_schema.py
```

2. Copy `.env.example` to `.env` and set DB credentials and `JWT_SECRET`.

3. Run the app:

```powershell
python app.py
```

Testing register

```bash
curl -X POST http://localhost:5000/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"alice@example.com","password":"secret123","full_name":"Alice"}'
```
