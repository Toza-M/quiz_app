import os
import json
import traceback
from flask import Flask, request, jsonify
from flask_cors import CORS
from openai import OpenAI
from PyPDF2 import PdfReader
from werkzeug.utils import secure_filename
from auth import auth

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}})
app.register_blueprint(auth, url_prefix='/auth')

class DeepSeekManager:
    _instance = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(DeepSeekManager, cls).__new__(cls)
            api_key = os.getenv('DEEPSEEK_API_KEY', 'sk-d55658690eff4cc281e892413e42e786')
            cls._instance.client = OpenAI(
                api_key=api_key, 
                base_url="https://api.deepseek.com"
            )
        return cls._instance

# Instance of the Singleton
ai_manager = DeepSeekManager()

UPLOAD_FOLDER = 'uploads'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

def extract_text_from_pdf(file_path):
    try:
        reader = PdfReader(file_path)
        text = "".join([p.extract_text() or "" for p in reader.pages])
        return text
    except Exception as e:
        print(f"PDF Error: {e}")
        return ""

@app.route('/generate-quiz', methods=['POST'])
def generate_quiz():
    file_path = None
    try:
        if 'file' not in request.files:
            return jsonify({"error": "No file uploaded"}), 400
        
        file = request.files['file']
        filename = secure_filename(file.filename)
        file_path = os.path.join(UPLOAD_FOLDER, filename)
        file.save(file_path)

        text_content = extract_text_from_pdf(file_path) if filename.endswith('.pdf') else file.read().decode('utf-8')
        if not text_content:
            return jsonify({"error": "Empty file"}), 400

        system_prompt = """
        Return a JSON object with key "questions". Each item has:
        "question", "options" (list), "answer_index" (int).
        """
        
        # Using the Singleton Client
        response = ai_manager.client.chat.completions.create(
            model="deepseek-chat",
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": f"Text: {text_content[:10000]}"}
            ],
            response_format={'type': 'json_object'}
        )

        content = json.loads(response.choices[0].message.content)
        return jsonify(content.get("questions", content)), 200

    except Exception as e:
        traceback.print_exc()
        return jsonify({"error": str(e)}), 500
    finally:
        if file_path and os.path.exists(file_path):
            os.remove(file_path)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)