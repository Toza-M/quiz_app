class Quiz {
  final String id;
  final String title;
  final String description;
  final double difficulty; // 1.0 to 5.0
  final List<Question> questions;
  final int duration; // in minutes

  Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.questions,
    required this.duration,
  });

  // Helper to convert difficulty number to text
  String get difficultyText {
    if (difficulty <= 2.0) return 'Beginner';
    if (difficulty <= 3.5) return 'Intermediate';
    return 'Advanced';
  }

  int get questionCount => questions.length;
}

class Question {
  final String id;
  final String text;
  final List<String> options;
  final int correctAnswerIndex; // This is the field that was missing

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctAnswerIndex, // Required in the constructor
  });
}
