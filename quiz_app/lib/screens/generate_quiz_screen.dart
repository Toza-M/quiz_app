import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdf/pdf.dart'; // Fixed import
import '../models/quiz_model.dart';
import 'quiz_session_screen.dart';

class GenerateQuizScreen extends StatefulWidget {
  const GenerateQuizScreen({super.key});

  @override
  State<GenerateQuizScreen> createState() => _GenerateQuizScreenState();
}

class _GenerateQuizScreenState extends State<GenerateQuizScreen> {
  final TextEditingController _textController = TextEditingController();
  bool _generating = false;
  List<int>? _pickedFileBytes;
  String? _pickedFileName;

  // Local fallback generator if backend is unavailable
  Quiz _buildQuizFromText(String text) {
    final now = DateTime.now();
    final idBase = now.millisecondsSinceEpoch;
    List<String> lines = text
        .split(RegExp(r"\r?\n"))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    if (lines.length < 5) {
      lines = [
        'Question 1',
        'Question 2',
        'Question 3',
        'Question 4',
        'Question 5'
      ];
    }

    final questions = <Question>[];
    for (int i = 0; i < 5; i++) {
      final source = lines[i % lines.length];
      questions.add(Question(
        id: 'q_$i',
        questionText: source,
        imageUrl: null,
        type: QuestionType.singleChoice,
        options: [
          Option(id: '1', text: 'Option A', isCorrect: true),
          Option(id: '2', text: 'Option B', isCorrect: false),
          Option(id: '3', text: 'Option C', isCorrect: false),
          Option(id: '4', text: 'Option D', isCorrect: false),
        ],
        explanation: 'Auto-generated.',
      ));
    }

    return Quiz(
      id: 'gen_$idBase',
      title: 'Generated Quiz',
      description: '5 questions',
      category: 'Generated',
      imageUrl: '',
      questionCount: 5,
      duration: 5,
      difficulty: 2.0,
      questions: questions,
      createdAt: now,
    );
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt', 'pdf'],
        withData: true, // Necessary for Web to get bytes
      );

      if (result == null) return;
      final file = result.files.first;
      String content = '';

      if (file.bytes != null) {
        _pickedFileBytes = file.bytes;
        _pickedFileName = file.name;

        if (file.extension?.toLowerCase() == 'pdf') {
          // SYNCFUSION PDF EXTRACTION
          final PdfDocument document = PdfDocument(inputBytes: file.bytes);
          content = PdfTextExtractor(document).extractText();
          document.dispose();
        } else {
          content = utf8.decode(file.bytes!);
        }
      }

      setState(() {
        _textController.text = content;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Pick file failed: $e')));
    }
  }

  void _onGenerate() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() => _generating = true);

    try {
      // Select backend host depending on platform
      String host;
      if (kIsWeb) {
        host = 'http://localhost:5000';
      } else if (Platform.isAndroid) {
        host = 'http://10.0.2.2:5000';
      } else {
        host = 'http://127.0.0.1:5000';
      }
      final backendUrl = '$host/generate-quiz';

      final request = http.MultipartRequest('POST', Uri.parse(backendUrl));

      if (_pickedFileBytes != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'file',
          _pickedFileBytes!,
          filename: _pickedFileName ?? 'upload.pdf',
        ));
      } else {
        // If user pasted text manually, send it as a virtual text file
        request.files.add(http.MultipartFile.fromBytes(
          'file',
          utf8.encode(text),
          filename: 'input.txt',
        ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final questions = <Question>[];

        for (int i = 0; i < data.length; i++) {
          final item = data[i];
          final opts = List<String>.from(item['options']);
          questions.add(Question(
            id: 'gen_q_$i',
            questionText: item['question'],
            imageUrl: null,
            type: QuestionType.singleChoice,
            options: List.generate(
                opts.length,
                (index) => Option(
                      id: 'opt_$index',
                      text: opts[index],
                      isCorrect: index == item['answer_index'],
                    )),
            explanation: '',
          ));
        }

        final quiz = Quiz(
          id: 'gen_${DateTime.now().millisecondsSinceEpoch}', // Fixed here
          title: 'AI Generated Quiz',
          description: 'Based on your file',
          category: 'AI',
          imageUrl: '',
          questionCount: questions.length,
          duration: 5,
          difficulty: 3.0,
          questions: questions,
          createdAt: DateTime.now(),
        );

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => QuizSessionScreen(quiz: quiz)),
        );
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      // Show error and fallback to local generation if server is down
      String message = 'Generate failed: $e';
      if (e is SocketException) {
        message = 'Could not connect to backend at $e.\n'
            'If you run on Android emulator use 10.0.2.2, on iOS simulator use localhost, '
            'or on a physical device use your machine IP.';
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
      final quiz = _buildQuizFromText(text);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => QuizSessionScreen(quiz: quiz)),
      );
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Generate Quiz'), backgroundColor: Colors.blue),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
                'Upload a PDF/TXT or paste text to generate 5 questions.'),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _pickFile,
                    icon: const Icon(Icons.file_upload),
                    label: const Text('Pick File'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _generating ? null : _onGenerate,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white),
                    child: _generating
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Generate Quiz'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Expanded(
              child: TextField(
                controller: _textController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText: 'Extracted text will appear here...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
