import 'package:flutter/material.dart';
import '../models/quiz_model.dart';
import 'score_screen.dart';

class QuizSessionScreen extends StatefulWidget {
  final Quiz quiz;

  const QuizSessionScreen({super.key, required this.quiz});

  @override
  State<QuizSessionScreen> createState() => _QuizSessionScreenState();
}

class _QuizSessionScreenState extends State<QuizSessionScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _selectedOptionIndex = -1;
  bool _isAnswered = false;

  void _answerQuestion(int index) {
    if (_isAnswered) return;

    setState(() {
      _selectedOptionIndex = index;
      _isAnswered = true;
      if (index ==
          widget.quiz.questions[_currentQuestionIndex].correctAnswerIndex) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.quiz.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOptionIndex = -1;
        _isAnswered = false;
      });
    } else {
      // Navigate to Score Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ScoreScreen(
            score: _score,
            totalQuestions: widget.quiz.questions.length,
            quiz: widget.quiz,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.quiz.questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.quiz.title,
          style: const TextStyle(fontFamily: 'Times New Roman'),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress
            Text(
              'Question ${_currentQuestionIndex + 1} / ${widget.quiz.questions.length}',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontFamily: 'Times New Roman',
              ),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / widget.quiz.questions.length,
              backgroundColor: Colors.grey.shade300,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 30),

            // Question Text
            Text(
              question.text,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Times New Roman',
              ),
            ),
            const SizedBox(height: 30),

            // Options
            ...List.generate(question.options.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: InkWell(
                  onTap: () => _answerQuestion(index),
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: _getOptionColor(index),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: _getOptionBorderColor(index),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            question.options[index],
                            style: TextStyle(
                              fontSize: 18,
                              color:
                                  _isAnswered &&
                                      index == question.correctAnswerIndex
                                  ? Colors.white
                                  : Colors.black87,
                              fontFamily: 'Times New Roman',
                            ),
                          ),
                        ),
                        if (_isAnswered)
                          if (index == question.correctAnswerIndex)
                            const Icon(Icons.check_circle, color: Colors.white)
                          else if (index == _selectedOptionIndex)
                            const Icon(Icons.cancel, color: Colors.red),
                      ],
                    ),
                  ),
                ),
              );
            }),

            const Spacer(),

            // Next Button
            if (_isAnswered)
              SizedBox(
                // FIXED: Container -> SizedBox
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    _currentQuestionIndex < widget.quiz.questions.length - 1
                        ? 'Next Question'
                        : 'See Results',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Times New Roman',
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Color _getOptionColor(int index) {
    if (!_isAnswered) return Colors.grey.shade100;

    if (index ==
        widget.quiz.questions[_currentQuestionIndex].correctAnswerIndex) {
      return Colors.green;
    }
    if (index == _selectedOptionIndex) {
      return Colors.red.withValues(alpha: 0.3); // FIXED: withValues
    }
    return Colors.grey.shade100;
  }

  Color _getOptionBorderColor(int index) {
    if (!_isAnswered) return Colors.grey.shade300;

    if (index ==
        widget.quiz.questions[_currentQuestionIndex].correctAnswerIndex) {
      return Colors.green;
    }
    if (index == _selectedOptionIndex) return Colors.red;

    return Colors.grey.shade300;
  }
}
