# 🧠 AI-Powered Quiz Application

A **cross-platform educational application** built with **Flutter** and **Flask** that transforms PDF and text-based learning materials into **interactive multiple-choice quizzes** using the **DeepSeek-V3 AI engine**.

This project demonstrates the practical application of **software engineering principles**, **design patterns**, and **AI integration** in a real-world academic system.

---

## 🚀 Key Features

### 🤖 AI-Driven Quiz Generation
- Upload **PDF** or **TXT** documents
- Automatically generate structured multiple-choice quizzes using **DeepSeek-V3**
- AI responses are parsed into reliable JSON-based quiz formats

### 🔐 Secure Authentication
- User registration and login
- Passwords securely hashed using **Werkzeug**
- No plain-text credentials stored

### 🔄 Persistent User Sessions
- Logged-in users remain authenticated across app restarts
- Session state stored efficiently using **Singleton services + SharedPreferences**

### 🌐 Cross-Platform Support
- Android
- iOS
- Windows Desktop
- Web-ready architecture

### 🎨 Modern User Interface
- Clean, gradient-based UI
- Professional typography (**Times New Roman**)
- Responsive layouts for multiple screen sizes

---

## 🛠️ Technology Stack

### Frontend
- **Framework:** Flutter (Dart)
- **State Management:** Singleton Pattern
- **Local Storage:** SharedPreferences
- **Architecture:** Separation of UI & Services (Repository Pattern)

### Backend
- **Framework:** Flask (Python)
- **AI Engine:** DeepSeek-V3 (OpenAI-compatible API)
- **Database:** SQLite
- **Security:** Werkzeug Password Hashing
- **API Style:** RESTful JSON-based endpoints

---

## 🏗️ Software Design Patterns

### 🔁 Singleton Pattern (Frontend)
- `AuthService` ensures a **single source of truth** for:
  - User data
  - Authentication tokens
  - API access
- Prevents redundant disk reads
- Guarantees consistent session state across all screens

### 🔁 Singleton Pattern (Backend)
- **DatabaseManager**
  - Controls SQLite access
  - Prevents database locking and write conflicts
- **DeepSeekManager**
  - Reuses AI API connections
  - Reduces latency and API initialization overhead

### 🗂️ Repository Pattern
- Decouples **UI widgets** from **data and API logic**
- Improves maintainability and testability
- Enables easier future backend migration

---

## 🚦 Getting Started

### 1️⃣ Backend Setup

```bash
cd backend
pip install -r requirements.txt
python app.py
```

Set your **DeepSeek API Key** in `app.py` before running the server.

---

### 2️⃣ Frontend Setup

```bash
cd quiz_app
flutter pub get
flutter run
```

---

## 🧪 Testing & Quality Assurance

### Backend Testing
```bash
python -m unittest tests/test_backend.py
```

### Frontend Testing
```bash
flutter test
```

---

## 📁 Project Structure

```plaintext
├── backend/
│   ├── tests/
│   ├── uploads/
│   ├── app.py
│   ├── auth.py
│   └── quiz_app.db
│
├── quiz_app/
│   ├── lib/
│   │   ├── screens/
│   │   ├── services/
│   │   └── main.dart
│   └── test/
│
└── Documents/
    ├── UML/
    └── Reports/
```

---

## 🎓 Academic Requirements – Phase 2

✅ Automated Testing  
✅ Design Patterns (Singleton & Repository)  
✅ UML Diagrams (Class, Sequence, Use Case)  
✅ AI Integration with structured JSON output  

---

## 📌 Conclusion

This project represents a **scalable, secure, and AI-enhanced educational system**, suitable for academic evaluation and future real-world deployment.
