from flask import Flask, request, jsonify
from werkzeug.utils import secure_filename
import re
import os
from typing import List, Dict

try:
    # optional: PyPDF2 for PDF text extraction
    import PyPDF2
except Exception:
    PyPDF2 = None

app = Flask(__name__)
app.config['MAX_CONTENT_LENGTH'] = 8 * 1024 * 1024  # 8 MB max upload
app.config['UPLOAD_EXTENSIONS'] = ['.txt', '.pdf']


def extract_text_from_pdf(stream) -> str:
    if PyPDF2 is None:
        raise RuntimeError('PyPDF2 not installed')
    reader = PyPDF2.PdfReader(stream)
    parts = []
    for page in reader.pages:
        try:
            parts.append(page.extract_text() or '')
        except Exception:
            continue
    return "\n".join(parts)


def extract_text(file_storage) -> str:
    filename = secure_filename(file_storage.filename or '')
    ext = os.path.splitext(filename)[1].lower()
    if ext == '.pdf':
        # read bytes and pass to PyPDF2
        if PyPDF2 is None:
            raise RuntimeError('PDF support is not available (PyPDF2 not installed)')
        file_storage.stream.seek(0)
        return extract_text_from_pdf(file_storage.stream)

    # default: treat as text
    data = file_storage.read()
    # try decode
    try:
        return data.decode('utf-8')
    except Exception:
        try:
            return data.decode('latin-1')
        except Exception:
            return ''


_sentence_split_re = re.compile(r'(?<=[.!?])\s+')
_word_re = re.compile(r"[A-Za-zÀ-ÖØ-öø-ÿ'-]+")


def generate_questions_from_text(text: str, count: int = 5) -> List[Dict[str, str]]:
    # Normalize whitespace
    text = re.sub(r'\s+', ' ', text).strip()
    if not text:
        return []

    sentences = [s.strip() for s in _sentence_split_re.split(text) if len(s.strip()) > 20]
    if not sentences:
        # fallback: split by lines
        sentences = [l.strip() for l in text.split('\n') if len(l.strip()) > 20]

    # score sentences by length (longer sentences likely contain facts)
    sentences_sorted = sorted(sentences, key=lambda s: len(s), reverse=True)

    selected = sentences_sorted[: max(count * 2, 10)]

    questions = []
    used_sentences = set()

    for s in selected:
        if len(questions) >= count:
            break
        if s in used_sentences:
            continue
        used_sentences.add(s)

        # Find candidate answer words (longer words first)
        words = _word_re.findall(s)
        # prefer words with letters and length >=5
        candidates = [w for w in words if len(w) >= 5]
        candidates = sorted(set(candidates), key=lambda w: -len(w))

        if not candidates and words:
            candidates = words

        if not candidates:
            continue

        answer = candidates[0]
        # replace first occurrence (case-insensitive)
        pattern = re.compile(re.escape(answer), re.IGNORECASE)
        question_text = pattern.sub('_____', s, count=1)

        # ensure question ends with question mark when appropriate
        if not question_text.endswith('?') and not question_text.endswith('.'):
            question_text = question_text.strip()
            if not question_text.endswith('?'):
                question_text = question_text + '?'

        questions.append({'question': question_text, 'answer': answer})

    # If we couldn't find enough, pad with short-question heuristics
    if len(questions) < count:
        # take remaining sentences or create generic questions
        for i, s in enumerate(sentences):
            if len(questions) >= count:
                break
            if s in used_sentences:
                continue
            words = _word_re.findall(s)
            answer = words[0] if words else ''
            q = s
            if answer:
                q = re.sub(re.escape(answer), '_____', s, count=1)
            if not q.endswith('?'):
                q = q.strip()
                q = q + '?'
            questions.append({'question': q, 'answer': answer})

    # limit to requested count
    return questions[:count]


@app.route('/generate', methods=['POST'])
def generate():
    """Accepts multipart/form-data with field 'file' (text or pdf) and optional 'count' param.
    Returns JSON with generated questions.
    """
    if 'file' not in request.files:
        return jsonify({'error': 'file field is required'}), 400

    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'no file selected'}), 400

    filename = secure_filename(file.filename)
    ext = os.path.splitext(filename)[1].lower()
    if ext not in app.config['UPLOAD_EXTENSIONS']:
        return jsonify({'error': f'unsupported file type: {ext}'}), 415

    try:
        text = extract_text(file)
    except RuntimeError as e:
        return jsonify({'error': str(e)}), 500

    count = 5
    try:
        if 'count' in request.form:
            count = int(request.form.get('count'))
            count = max(1, min(10, count))
    except Exception:
        count = 5

    questions = generate_questions_from_text(text, count=count)

    return jsonify({
        'filename': filename,
        'sentence_count': len([s for s in _sentence_split_re.split(text) if s.strip()]),
        'questions': questions,
    })


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
