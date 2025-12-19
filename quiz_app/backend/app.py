import os
import json
import traceback
from flask import Flask, request, jsonify
from flask_cors import CORS
from openai import OpenAI # Switched from google.genai
from PyPDF2 import PdfReader
from werkzeug.utils import secure_filename

# Import the blueprint from your auth.py file
from auth import auth

app = Flask(__name__)

# IMPORTANT: Enable CORS for the whole app and specific prefixes
CORS(app, resources={r"/*": {"origins": "*"}})

# Register the auth blueprint
app.register_blueprint(auth, url_prefix='/auth')

# --- CONFIGURATION FOR DEEPSEEK ---
# Use the API Key provided
DEEPSEEK_API_KEY = os.getenv('DEEPSEEK_API_KEY', 'sk-d55658690eff4cc281e892413e42e786')

# Initialize OpenAI client pointing to DeepSeek's URL
client = OpenAI(
    api_key=DEEPSEEK_API_KEY, 
    base_url="https://api.deepseek.com"
)

UPLOAD_FOLDER = 'uploads'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

def extract_text_from_pdf(file_path):
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

@app.route('/generate-quiz', methods=['POST'])
def generate_quiz():
    file_path = None
    try:
        # 1. File Upload Handling
        if 'file' not in request.files:
            return jsonify({"error": "No file uploaded"}), 400
        
        file = request.files['file']
        if file.filename == '':
            return jsonify({"error": "No selected file"}), 400

        filename = secure_filename(file.filename)
        file_path = os.path.join(UPLOAD_FOLDER, filename)
        file.save(file_path)

        # 2. Extract Text
        if filename.endswith('.pdf'):
            text_content = extract_text_from_pdf(file_path)
        else:
            try:
                # For .txt files
                file.seek(0)
                text_content = file.read().decode('utf-8')
            except:
                text_content = ""

        if not text_content:
            return jsonify({"error": "Could not extract text from file"}), 400

        # 3. Define System Prompt for JSON Structure
        system_prompt = """
        You are a helpful AI that generates quizzes based on provided text.
        You MUST return the output as a valid JSON object.
        The JSON object must have a key "questions" which is a list.
        Each item in the list must look like this:
        {
            "question": "The question string",
            "options": ["Option 1", "Option 2", "Option 3", "Option 4"],
            "answer_index": 0 
        }
        (answer_index is the 0-based integer index of the correct option).
        Do not include Markdown formatting (like ```json). Just return the raw JSON string.
        """

        user_prompt = f"Generate 5 multiple-choice questions based on this text:\n\n{text_content[:12000]}"

        # 4. Call DeepSeek API
        print("Sending request to DeepSeek...")
        response = client.chat.completions.create(
            model="deepseek-chat",
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": user_prompt},
            ],
            response_format={'type': 'json_object'}, # Forces JSON mode
            temperature=1.1,
            stream=False
        )

        # 5. Parse Response
        content = response.choices[0].message.content
        print("DeepSeek Response Received.")
        
        try:
            parsed_json = json.loads(content)
            
            # DeepSeek usually returns { "questions": [...] }
            if isinstance(parsed_json, dict) and "questions" in parsed_json:
                return jsonify(parsed_json["questions"]), 200
            elif isinstance(parsed_json, list):
                return jsonify(parsed_json), 200
            else:
                return jsonify({"error": "AI format error"}), 500

        except json.JSONDecodeError:
            return jsonify({"error": "Invalid JSON from AI"}), 500

    except Exception as e:
        print("!!!!!!!! SERVER ERROR !!!!!!!!")
        traceback.print_exc()
        return jsonify({"error": str(e)}), 500
    finally:
        if file_path and os.path.exists(file_path):
            try:
                os.remove(file_path)
            except:
                pass

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)