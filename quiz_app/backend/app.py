import os
import json
import traceback
from flask import Flask, request, jsonify
from flask_cors import CORS
from google import genai
from google.genai import types
from PyPDF2 import PdfReader
from werkzeug.utils import secure_filename

# Import your auth blueprint
from auth import auth

app = Flask(__name__)

# 1. Enable CORS for everything
CORS(app, resources={r"/*": {"origins": "*"}})

# 2. Register Auth Blueprint
app.register_blueprint(auth, url_prefix='/auth')

# --- CONFIGURATION ---
# Replace with your actual key if needed
GEMINI_API_KEY = os.getenv('GEMINI_API_KEY', 'AIzaSyD9jyIBEJszuew1BQ1U3vv6-aWQp3u0fDY') 
client = genai.Client(api_key=GEMINI_API_KEY)

UPLOAD_FOLDER = 'uploads'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

def extract_text(file_path):
    """Extracts text from PDF or TXT files."""
    if file_path.endswith('.pdf'):
        try:
            reader = PdfReader(file_path)
            text = ""
            for page in reader.pages:
                content = page.extract_text()
                if content: text += content
            return text
        except Exception as e:
            print(f"Error reading PDF: {e}")
            return ""
    else:
        # Fallback for txt files
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                return f.read()
        except Exception as e:
            print(f"Error reading text file: {e}")
            return ""

@app.route('/generate-quiz', methods=['POST'])
def generate_quiz():
    file_path = None
    try:
        # 1. Check file presence
        if 'file' not in request.files:
            return jsonify({"error": "No file uploaded"}), 400
        
        file = request.files['file']
        if file.filename == '':
            return jsonify({"error": "No selected file"}), 400

        filename = secure_filename(file.filename)
        file_path = os.path.join(UPLOAD_FOLDER, filename)
        file.save(file_path)

        # 2. Extract Text
        text_content = extract_text(file_path)
        if not text_content:
             return jsonify({"error": "Could not extract text from file"}), 400

        # --- FIX: UPDATED MODEL ID ---
        # We use the specific version 'gemini-1.5-flash-001' which is more stable.
        # If this fails, try 'gemini-1.0-pro'
        model_id = 'gemini-1.0-pro' 
        
        prompt = "Generate 5 multiple-choice questions based on this text. Return JSON array."

        # 3. Define JSON Schema
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

        # 4. Call API
        print(f"Sending request to Gemini model: {model_id}...")
        
        response = client.models.generate_content(
            model=model_id,
            contents=[prompt, text_content[:15000]], # Limit text length to avoid token limits
            config=types.GenerateContentConfig(
                response_mime_type='application/json',
                response_json_schema=quiz_schema,
                temperature=0.7,
            ),
        )

        # 5. Return Result
        print("Gemini response received successfully.")
        
        # Handle cases where response might be empty or invalid
        if not response.parsed:
             print("Raw response text:", response.text)
             return jsonify({"error": "AI returned empty JSON"}), 500

        return jsonify(response.parsed), 200

    except Exception as e:
        # --- DEBUGGING BLOCK ---
        print("\n!!!!!!!!!! SERVER ERROR !!!!!!!!!!!")
        print(f"Error Message: {str(e)}")
        print("Traceback:")
        traceback.print_exc() 
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n")
        
        # Return the specific error to the frontend
        return jsonify({"error": f"Server Error: {str(e)}"}), 500
        
    finally:
        # Cleanup
        if file_path and os.path.exists(file_path):
            try:
                os.remove(file_path)
            except:
                pass

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)