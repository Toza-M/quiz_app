class Quiz {
  final String id;
  final String title;
  final String description;
  final String category;
  final String imageUrl;
  final int questionCount;
  final int duration; // in minutes
  final double difficulty; // 1.0 to 5.0
  final List<Question> questions;
  final DateTime createdAt;

  Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.questionCount,
    required this.duration,
    required this.difficulty,
    required this.questions,
    required this.createdAt,
  });

  // Helper method to get difficulty as text
  String get difficultyText {
    if (difficulty <= 2.0) return 'Easy';
    if (difficulty <= 3.5) return 'Medium';
    return 'Hard';
  }

  // Convert to map for Firestore (if you use Firebase later)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'imageUrl': imageUrl,
      'questionCount': questionCount,
      'duration': duration,
      'difficulty': difficulty,
      'questions': questions.map((q) => q.toMap()).toList(),
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  // Create from map
  factory Quiz.fromMap(Map<String, dynamic> map) {
    return Quiz(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      category: map['category'],
      imageUrl: map['imageUrl'],
      questionCount: map['questionCount'],
      duration: map['duration'],
      difficulty: map['difficulty'],
      questions: List<Question>.from(
          map['questions']?.map((x) => Question.fromMap(x)) ?? []),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }
}

class Question {
  final String id;
  final String questionText;
  final String? imageUrl;
  final QuestionType type;
  final List<Option> options;
  final String explanation; // Explanation shown after answering

  Question({
    required this.id,
    required this.questionText,
    this.imageUrl,
    required this.type,
    required this.options,
    required this.explanation,
  });

  // Convert to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'questionText': questionText,
      'imageUrl': imageUrl,
      'type': type.toString(),
      'options': options.map((o) => o.toMap()).toList(),
      'explanation': explanation,
    };
  }

  // Create from map
  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'],
      questionText: map['questionText'],
      imageUrl: map['imageUrl'],
      type: QuestionType.values.firstWhere(
        (e) => e.toString() == map['type'],
        orElse: () => QuestionType.singleChoice,
      ),
      options: List<Option>.from(
          map['options']?.map((x) => Option.fromMap(x)) ?? []),
      explanation: map['explanation'],
    );
  }
}

class Option {
  final String id;
  final String text;
  final bool isCorrect;
  final String? imageUrl;

  Option({
    required this.id,
    required this.text,
    required this.isCorrect,
    this.imageUrl,
  });

  // Convert to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'isCorrect': isCorrect,
      'imageUrl': imageUrl,
    };
  }

  // Create from map
  factory Option.fromMap(Map<String, dynamic> map) {
    return Option(
      id: map['id'],
      text: map['text'],
      isCorrect: map['isCorrect'],
      imageUrl: map['imageUrl'],
    );
  }
}

// Different types of questions you might want to support
enum QuestionType {
  singleChoice,
  multipleChoice,
  trueFalse,
  // You can add more types later
}

// Class to represent user's quiz attempt
class QuizAttempt {
  final String id;
  final String quizId;
  final String userId;
  final int score;
  final int totalQuestions;
  final int correctAnswers;
  final int incorrectAnswers;
  final int timeSpent; // in seconds
  final DateTime completedAt;
  final List<UserAnswer> userAnswers;

  QuizAttempt({
    required this.id,
    required this.quizId,
    required this.userId,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.timeSpent,
    required this.completedAt,
    required this.userAnswers,
  });

  double get percentage => (correctAnswers / totalQuestions) * 100;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quizId': quizId,
      'userId': userId,
      'score': score,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'incorrectAnswers': incorrectAnswers,
      'timeSpent': timeSpent,
      'completedAt': completedAt.millisecondsSinceEpoch,
      'userAnswers': userAnswers.map((a) => a.toMap()).toList(),
    };
  }

  factory QuizAttempt.fromMap(Map<String, dynamic> map) {
    return QuizAttempt(
      id: map['id'],
      quizId: map['quizId'],
      userId: map['userId'],
      score: map['score'],
      totalQuestions: map['totalQuestions'],
      correctAnswers: map['correctAnswers'],
      incorrectAnswers: map['incorrectAnswers'],
      timeSpent: map['timeSpent'],
      completedAt: DateTime.fromMillisecondsSinceEpoch(map['completedAt']),
      userAnswers: List<UserAnswer>.from(
          map['userAnswers']?.map((x) => UserAnswer.fromMap(x)) ?? []),
    );
  }
}

// Class to store user's answers for each question
class UserAnswer {
  final String questionId;
  final List<String> selectedOptionIds; // For multiple choice
  final bool isCorrect;
  final int timeSpent; // seconds spent on this question

  UserAnswer({
    required this.questionId,
    required this.selectedOptionIds,
    required this.isCorrect,
    required this.timeSpent,
  });

  Map<String, dynamic> toMap() {
    return {
      'questionId': questionId,
      'selectedOptionIds': selectedOptionIds,
      'isCorrect': isCorrect,
      'timeSpent': timeSpent,
    };
  }

  factory UserAnswer.fromMap(Map<String, dynamic> map) {
    return UserAnswer(
      questionId: map['questionId'],
      selectedOptionIds: List<String>.from(map['selectedOptionIds'] ?? []),
      isCorrect: map['isCorrect'],
      timeSpent: map['timeSpent'],
    );
  }
}

// User profile model
class UserProfile {
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
  final int totalQuizzesTaken;
  final int totalCorrectAnswers;
  final int totalQuestionsAttempted;
  final double averageScore;
  final DateTime joinedAt;

  UserProfile({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    required this.totalQuizzesTaken,
    required this.totalCorrectAnswers,
    required this.totalQuestionsAttempted,
    required this.averageScore,
    required this.joinedAt,
  });

  double get successRate {
    if (totalQuestionsAttempted == 0) return 0.0;
    return (totalCorrectAnswers / totalQuestionsAttempted) * 100;
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'totalQuizzesTaken': totalQuizzesTaken,
      'totalCorrectAnswers': totalCorrectAnswers,
      'totalQuestionsAttempted': totalQuestionsAttempted,
      'averageScore': averageScore,
      'joinedAt': joinedAt.millisecondsSinceEpoch,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'],
      email: map['email'],
      displayName: map['displayName'],
      photoUrl: map['photoUrl'],
      totalQuizzesTaken: map['totalQuizzesTaken'],
      totalCorrectAnswers: map['totalCorrectAnswers'],
      totalQuestionsAttempted: map['totalQuestionsAttempted'],
      averageScore: map['averageScore'],
      joinedAt: DateTime.fromMillisecondsSinceEpoch(map['joinedAt']),
    );
  }
}