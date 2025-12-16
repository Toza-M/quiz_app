import 'package:flutter/material.dart';
import '../models/quiz_model.dart';
import 'home_screen.dart';

class ScoreScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final Quiz quiz;

  const ScoreScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.quiz,
  });

  @override
  Widget build(BuildContext context) {
    final double percentage = (score / totalQuestions) * 100;
    String message = '';
    Color color = Colors.blue;

    if (percentage >= 90) {
      message = 'Excellent!';
      color = Colors.green;
    } else if (percentage >= 70) {
      message = 'Good Job!';
      color = Colors.blue;
    } else if (percentage >= 50) {
      message = 'Fair Attempt';
      color = Colors.orange;
    } else {
      message = 'Keep Practicing';
      color = Colors.red;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                color.withValues(alpha: 0.8),
                Colors.white,
              ],
              stops: const [0.0, 0.4],
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 80),

              // Result Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        percentage >= 50 ? Icons.emoji_events : Icons.refresh,
                        size: 80,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: color,
                        fontFamily: 'Times New Roman',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'You scored',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                        fontFamily: 'Times New Roman',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '$score',
                          style: TextStyle(
                            // FIXED: Added const to TextStyle if possible, but actually the error was likely on the whole Text or Row
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          ' / $totalQuestions',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Stats
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatItem('Correct', '$score', Colors.green),
                    _buildStatItem(
                        'Wrong', '${totalQuestions - score}', Colors.red),
                    _buildStatItem('Total', '$totalQuestions', Colors.blue),
                  ],
                ),
              ),

              const SizedBox(height: 60),

              // Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const HomeScreen(), // FIXED: Added const
                        ),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      'Back to Home',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Times New Roman',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
            fontFamily: 'Times New Roman',
          ),
        ),
      ],
    );
  }
}
