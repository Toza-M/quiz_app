AI Quiz App 🧠✨
An advanced, AI-powered platform that transforms study materials into interactive quizzes. Using the power of Google Gemini, this application automates the creation of assessments from PDFs, images, and text files to enhance the learning experience.

🚀 Key Features
AI Quiz Generation: Automatically generate multiple-choice questions from uploaded documents (PDF, JPG, PNG) using the Gemini Pro API.

Smart Authentication: Secure user registration and login system with persistent session management.

Quiz Management: Create, save, and review your history of generated quizzes.

Performance Tracking: Detailed score analysis after every session to track learning progress.

Cross-Platform: Built with Flutter for a seamless experience on Android, iOS, and Web.

🛠️ Tech Stack
Frontend: Flutter (Dart)

Backend: Flask (Python)

AI Integration: Google Generative AI (Gemini Pro)

Database: SQLite for user data and quiz history

CI/CD: GitHub Actions for automated Dart workflows

📋 Project Structure
Plaintext

quiz_app/
├── quiz_app/            # Flutter Mobile/Web Application
│   ├── lib/             # Application source code
│   └── pubspec.yaml     # Flutter dependencies
├── backend/             # Python Flask Server
│   ├── app.py           # Main API (AI generation logic)
│   ├── auth.py          # Authentication & Database logic
│   └── schema.sql       # Database structure
└── Documents/           # Project Diagrams & Requirements

⚙️ Installation & Setup
Prerequisites:
Flutter SDK

Python 3.10+

Gemini API Key

1. Backend Setup
Bash

cd quiz_app/backend
pip install -r requirements.txt
# Create a .env file and add: GEMINI_API_KEY=your_key_here
python run_schema.py   # Initialize the database
python app.py          # Start the server (default: port 5000)
2. Frontend Setup
Bash

cd quiz_app
flutter pub get
flutter run
🧪 Testing
The backend includes a comprehensive test suite to ensure API reliability:

Bash

cd quiz_app/backend
pytest tests/test_backend.py
📄 License
This project is part of a Software Engineering project focused on AI-driven educational tools.

Developed by the Quiz App Team.
