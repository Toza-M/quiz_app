import os
import json
from flask import Flask, request, jsonify
from flask_cors import CORS
from google import genai
from google.genai import types
from PyPDF2 import PdfReader
from werkzeug.utils import secure_filename

# Import the blueprint from your auth.py file
from auth import auth

app = Flask(__name__)

# IMPORTANT: Enable CORS for the whole app and specific prefixes
CORS(app, resources={r"/*": {"origins": "*"}})

# Register the auth blueprint with the /auth prefix
# This makes the login route accessible at /auth/login
app.register_blueprint(auth, url_prefix='/auth')

# Configuration for Gemini
GEMINI_API_KEY = os.getenv('GEMINI_API_KEY', 'AIzaSyD9jyIBEJszuew1BQ1U3vv6-aWQp3u0fDY')
client = genai.Client(api_key=GEMINI_API_KEY)
UPLOAD_FOLDER = 'uploads'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

def extract_text_from_pdf(file_path):
    reader = PdfReader(file_path)
    text = ""
    for page in reader.pages:
        content = page.extract_text()
        if content: text += content
    return text

@app.route('/generate-quiz', methods=['POST'])
def generate_quiz():
    if 'file' not in request.files:
        return jsonify({"error": "No file uploaded"}), 400
    
    file = request.files['file']
    filename = secure_filename(file.filename)
    file_path = os.path.join(UPLOAD_FOLDER, filename)
    file.save(file_path)

    try:
        if filename.endswith('.pdf'):
            text_content = extract_text_from_pdf(file_path)
        else:
            text_content = file.read().decode('utf-8')

        model_id = 'gemini-1.5-flash'
        prompt = "Generate 5 multiple-choice questions based on the text. Return a JSON array."
        
        quiz_schema = {
            'type': 'array',
            'items': {
                'type': 'object',
                'properties': {
                    'question': {'type': 'string'},
                    'options': {'type': 'array', 'items': {'type': 'string'}},
                    'answer_index': {'type': 'integer'},
                },
                'required': ['question', 'options', 'answer_index'],
            },
        }

        response = client.models.generate_content(
            model=model_id,
            contents=[prompt, text_content[:15000]],
            config=types.GenerateContentConfig(
                response_mime_type='application/json',
                response_json_schema=quiz_schema,
                temperature=0.7,
            ),
        )

        return jsonify(response.parsed), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        if os.path.exists(file_path):
            os.remove(file_path)

if __name__ == '__main__':
    # Running on 0.0.0.0 makes it accessible to your network/emulators
    app.run(host='0.0.0.0', port=5000, debug=True)