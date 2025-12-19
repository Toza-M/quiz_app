import 'package:flutter/material.dart';
import 'generate_quiz_screen.dart';

class MyQuizzesScreen extends StatelessWidget {
  const MyQuizzesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Quizzes',
          style: TextStyle(
            fontFamily: 'Times New Roman',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Generate a quiz from your file or paste text below.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Times New Roman',
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.upload_file, color: Colors.blue),
                title: const Text('Add file to generate quiz'),
                subtitle: const Text('Generate a 5-question quiz from a file'),
                trailing: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GenerateQuizScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Generate'),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Placeholder for user's generated quizzes
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.quiz, size: 72, color: Colors.grey),
                    SizedBox(height: 12),
                    Text(
                      'No generated quizzes yet',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
