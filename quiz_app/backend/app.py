<<<<<<< HEAD
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
# Replace with your actual DeepSeek API Key
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
                text_content = file.read().decode('utf-8')
            except:
                text_content = ""

        if not text_content:
            return jsonify({"error": "Could not extract text from file"}), 400

        # 3. Define System Prompt for JSON Structure
        # DeepSeek V3 works best when you explicitly describe the JSON in the system prompt
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
            
            # Normalize the output to ensure we send a List back to Flutter
            # DeepSeek might return { "questions": [...] }
            if isinstance(parsed_json, dict) and "questions" in parsed_json:
                return jsonify(parsed_json["questions"]), 200
            elif isinstance(parsed_json, list):
                return jsonify(parsed_json), 200
            else:
                print("Unexpected JSON structure:", parsed_json)
                return jsonify({"error": "AI format error"}), 500

        except json.JSONDecodeError:
            print("Failed to decode JSON:", content)
            return jsonify({"error": "Invalid JSON from AI"}), 500

    except Exception as e:
        print("!!!!!!!! SERVER ERROR !!!!!!!!")
        traceback.print_exc()
        return jsonify({"error": str(e)}), 500
    finally:
        if file_path and os.path.exists(file_path):
            os.remove(file_path)

if __name__ == '__main__':
=======
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
>>>>>>> 39aad75927553873c2f5c7249674e37404365eb7
    app.run(host='0.0.0.0', port=5000, debug=True)