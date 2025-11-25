import 'package:flutter/material.dart';
import '../models/quiz_model.dart';

class ScoreScreen extends StatelessWidget {
  final Quiz quiz;
  final Map<String, List<String>> userAnswers; // questionId -> selectedOptionIds
  final int timeSpent; // in seconds

  const ScoreScreen({
    super.key,
    required this.quiz,
    required this.userAnswers,
    required this.timeSpent,
  });

  int get correctAnswers {
    int correct = 0;
    for (final question in quiz.questions) {
      final userSelected = userAnswers[question.id] ?? [];
      final correctOptions = question.options.where((opt) => opt.isCorrect).map((opt) => opt.id).toList();
      
      // For single choice questions, check if the selected option is correct
      if (userSelected.isNotEmpty && 
          correctOptions.contains(userSelected.first) &&
          userSelected.length == 1) {
        correct++;
      }
    }
    return correct;
  }

  int get totalQuestions => quiz.questions.length;

  double get percentage => (correctAnswers / totalQuestions) * 100;

  String get performanceText {
    if (percentage >= 90) return 'Excellent! 🎉';
    if (percentage >= 80) return 'Very Good! 👍';
    if (percentage >= 70) return 'Good! 😊';
    if (percentage >= 60) return 'Fair 👌';
    return 'Needs Improvement 📚';
  }

  Color get performanceColor {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.orange;
    return Colors.red;
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quiz Results',
          style: TextStyle(
            fontFamily: 'Times New Roman',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Score Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue.shade600,
                    Colors.purple.shade600,
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Performance Text
                  Text(
                    performanceText,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Times New Roman',
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Score Circle
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Background Circle
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      // Percentage
                      Text(
                        '${percentage.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Times New Roman',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Score Details
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildScoreDetail('Correct', '$correctAnswers', Colors.green),
                      _buildScoreDetail('Total', '$totalQuestions', Colors.blue),
                      _buildScoreDetail('Time', _formatTime(timeSpent), Colors.orange),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Detailed Report
            const Text(
              'Detailed Report',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Times New Roman',
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Review your answers and explanations',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontFamily: 'Times New Roman',
              ),
            ),
            const SizedBox(height: 20),

            // Questions Review
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: quiz.questions.length,
              itemBuilder: (context, index) {
                final question = quiz.questions[index];
                final userSelected = userAnswers[question.id] ?? [];
                final correctOptions = question.options.where((opt) => opt.isCorrect).map((opt) => opt.id).toList();
                final isCorrect = userSelected.isNotEmpty && 
                                 correctOptions.contains(userSelected.first) &&
                                 userSelected.length == 1;

                return _buildQuestionReview(
                  context,
                  question: question,
                  userSelected: userSelected,
                  isCorrect: isCorrect,
                  questionNumber: index + 1,
                );
              },
            ),
            const SizedBox(height: 30),

            // Action Buttons
            Row(
              children: [
                // Retry Quiz - Simplified to just pop back
                Expanded(
                  child: Container(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Simply go back to restart the quiz
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Try Again',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Times New Roman',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                // Back to Home
                Expanded(
                  child: Container(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context, 
                          '/home', 
                          (route) => false
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        'Back to Home',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Times New Roman',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreDetail(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
            fontFamily: 'Times New Roman',
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Times New Roman',
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionReview(
    BuildContext context, {
    required Question question,
    required List<String> userSelected,
    required bool isCorrect,
    required int questionNumber,
  }) {
    final userSelectedOption = userSelected.isNotEmpty 
        ? question.options.firstWhere((opt) => opt.id == userSelected.first, orElse: () => question.options[0])
        : null;
    final correctOption = question.options.firstWhere((opt) => opt.isCorrect);

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isCorrect ? Colors.green : Colors.red,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question Header
            Row(
              children: [
                // Status Icon
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCorrect ? Colors.green : Colors.red,
                  ),
                  child: Icon(
                    isCorrect ? Icons.check : Icons.close,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                // Question Number
                Text(
                  'Question $questionNumber',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Times New Roman',
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            
            // Question Text
            Text(
              question.questionText,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Times New Roman',
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),

            // Your Answer
            _buildAnswerSection(
              'Your Answer:',
              userSelectedOption?.text ?? 'Not answered',
              isCorrect ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 10),

            // Correct Answer
            _buildAnswerSection(
              'Correct Answer:',
              correctOption.text,
              Colors.green,
            ),
            const SizedBox(height: 15),

            // Explanation
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Explanation:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Times New Roman',
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    question.explanation,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Times New Roman',
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerSection(String title, String answer, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: 'Times New Roman',
            color: color,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Text(
            answer,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Times New Roman',
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}