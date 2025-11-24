import '../models/quiz_model.dart';

class DummyData {
  static List<Quiz> getDummyQuizzes() {
    return [
      Quiz(
        id: '1',
        title: 'Flutter Basics',
        description: 'Test your knowledge of Flutter fundamentals',
        category: 'Programming',
        imageUrl: 'assets/images/flutter_quiz.jpg',
        questionCount: 5,
        duration: 10,
        difficulty: 2.5,
        createdAt: DateTime(2024, 1, 15),
        questions: [
          Question(
            id: '1_1',
            questionText: 'What is Flutter?',
            type: QuestionType.singleChoice,
            explanation: 'Flutter is Google\'s UI toolkit for building beautiful, natively compiled applications for mobile, web, and desktop from a single codebase.',
            options: [
              Option(id: '1_1_1', text: 'A programming language', isCorrect: false),
              Option(id: '1_1_2', text: 'A database management system', isCorrect: false),
              Option(id: '1_1_3', text: 'A UI toolkit for building cross-platform apps', isCorrect: true),
              Option(id: '1_1_4', text: 'A version control system', isCorrect: false),
            ],
          ),
          Question(
            id: '1_2',
            questionText: 'Which programming language is used by Flutter?',
            type: QuestionType.singleChoice,
            explanation: 'Flutter uses Dart as its primary programming language, which is also developed by Google.',
            options: [
              Option(id: '1_2_1', text: 'JavaScript', isCorrect: false),
              Option(id: '1_2_2', text: 'Python', isCorrect: false),
              Option(id: '1_2_3', text: 'Java', isCorrect: false),
              Option(id: '1_2_4', text: 'Dart', isCorrect: true),
            ],
          ),
          Question(
            id: '1_3',
            questionText: 'What widget would you use for a scrollable list?',
            type: QuestionType.singleChoice,
            explanation: 'ListView is used to create a scrollable list of widgets arranged linearly.',
            options: [
              Option(id: '1_3_1', text: 'Container', isCorrect: false),
              Option(id: '1_3_2', text: 'Column', isCorrect: false),
              Option(id: '1_3_3', text: 'ListView', isCorrect: true),
              Option(id: '1_3_4', text: 'Stack', isCorrect: false),
            ],
          ),
          Question(
            id: '1_4',
            questionText: 'Which of the following are state management solutions in Flutter?',
            type: QuestionType.multipleChoice,
            explanation: 'Provider, Bloc, and Riverpod are all popular state management solutions in the Flutter ecosystem.',
            options: [
              Option(id: '1_4_1', text: 'Provider', isCorrect: true),
              Option(id: '1_4_2', text: 'Bloc', isCorrect: true),
              Option(id: '1_4_3', text: 'Riverpod', isCorrect: true),
              Option(id: '1_4_4', text: 'SQLite', isCorrect: false),
            ],
          ),
          Question(
            id: '1_5',
            questionText: 'Flutter can only build mobile applications.',
            type: QuestionType.trueFalse,
            explanation: 'Flutter can build applications for mobile, web, desktop, and embedded devices from a single codebase.',
            options: [
              Option(id: '1_5_1', text: 'True', isCorrect: false),
              Option(id: '1_5_2', text: 'False', isCorrect: true),
            ],
          ),
        ],
      ),
      Quiz(
        id: '2',
        title: 'Dart Programming',
        description: 'Master the Dart programming language concepts',
        category: 'Programming',
        imageUrl: 'assets/images/dart_quiz.jpg',
        questionCount: 3,
        duration: 5,
        difficulty: 3.0,
        createdAt: DateTime(2024, 1, 20),
        questions: [
          Question(
            id: '2_1',
            questionText: 'Dart is an object-oriented language.',
            type: QuestionType.trueFalse,
            explanation: 'Dart is a strictly object-oriented language where everything is an object.',
            options: [
              Option(id: '2_1_1', text: 'True', isCorrect: true),
              Option(id: '2_1_2', text: 'False', isCorrect: false),
            ],
          ),
          Question(
            id: '2_2',
            questionText: 'What is the purpose of the "async" keyword in Dart?',
            type: QuestionType.singleChoice,
            explanation: 'The async keyword is used to mark a function as asynchronous, allowing it to use await for asynchronous operations.',
            options: [
              Option(id: '2_2_1', text: 'To define a synchronous function', isCorrect: false),
              Option(id: '2_2_2', text: 'To mark a function as asynchronous', isCorrect: true),
              Option(id: '2_2_3', text: 'To create a new thread', isCorrect: false),
              Option(id: '2_2_4', text: 'To optimize performance', isCorrect: false),
            ],
          ),
          Question(
            id: '2_3',
            questionText: 'Which keyword is used to define a constant that is known at compile time?',
            type: QuestionType.singleChoice,
            explanation: 'The "const" keyword is used for compile-time constants, while "final" is for run-time constants.',
            options: [
              Option(id: '2_3_1', text: 'var', isCorrect: false),
              Option(id: '2_3_2', text: 'final', isCorrect: false),
              Option(id: '2_3_3', text: 'const', isCorrect: true),
              Option(id: '2_3_4', text: 'static', isCorrect: false),
            ],
          ),
        ],
      ),
      Quiz(
        id: '3',
        title: 'General Knowledge',
        description: 'Test your general knowledge with this fun quiz',
        category: 'General',
        imageUrl: 'assets/images/gk_quiz.jpg',
        questionCount: 4,
        duration: 8,
        difficulty: 2.0,
        createdAt: DateTime(2024, 1, 25),
        questions: [
          Question(
            id: '3_1',
            questionText: 'What is the capital of France?',
            type: QuestionType.singleChoice,
            explanation: 'Paris is the capital and most populous city of France.',
            options: [
              Option(id: '3_1_1', text: 'London', isCorrect: false),
              Option(id: '3_1_2', text: 'Berlin', isCorrect: false),
              Option(id: '3_1_3', text: 'Paris', isCorrect: true),
              Option(id: '3_1_4', text: 'Madrid', isCorrect: false),
            ],
          ),
          Question(
            id: '3_2',
            questionText: 'Which planet is known as the Red Planet?',
            type: QuestionType.singleChoice,
            explanation: 'Mars is often called the Red Planet due to its reddish appearance.',
            options: [
              Option(id: '3_2_1', text: 'Jupiter', isCorrect: false),
              Option(id: '3_2_2', text: 'Mars', isCorrect: true),
              Option(id: '3_2_3', text: 'Venus', isCorrect: false),
              Option(id: '3_2_4', text: 'Saturn', isCorrect: false),
            ],
          ),
          Question(
            id: '3_3',
            questionText: 'What is the largest mammal in the world?',
            type: QuestionType.singleChoice,
            explanation: 'The blue whale is the largest mammal and the largest animal to have ever existed on Earth.',
            options: [
              Option(id: '3_3_1', text: 'African Elephant', isCorrect: false),
              Option(id: '3_3_2', text: 'Blue Whale', isCorrect: true),
              Option(id: '3_3_3', text: 'Giraffe', isCorrect: false),
              Option(id: '3_3_4', text: 'Polar Bear', isCorrect: false),
            ],
          ),
          Question(
            id: '3_4',
            questionText: 'Which of these are programming languages?',
            type: QuestionType.multipleChoice,
            explanation: 'Python, Java, and C++ are programming languages, while HTML is a markup language.',
            options: [
              Option(id: '3_4_1', text: 'Python', isCorrect: true),
              Option(id: '3_4_2', text: 'HTML', isCorrect: false),
              Option(id: '3_4_3', text: 'Java', isCorrect: true),
              Option(id: '3_4_4', text: 'C++', isCorrect: true),
            ],
          ),
        ],
      ),
    ];
  }

  static UserProfile getDummyUserProfile() {
    return UserProfile(
      uid: 'user_123',
      email: 'student@university.edu',
      displayName: 'John Doe',
      photoUrl: null,
      totalQuizzesTaken: 12,
      totalCorrectAnswers: 85,
      totalQuestionsAttempted: 120,
      averageScore: 78.5,
      joinedAt: DateTime(2024, 1, 1),
    );
  }

  static QuizAttempt getDummyQuizAttempt() {
    return QuizAttempt(
      id: 'attempt_1',
      quizId: '1',
      userId: 'user_123',
      score: 80,
      totalQuestions: 5,
      correctAnswers: 4,
      incorrectAnswers: 1,
      timeSpent: 234, // seconds
      completedAt: DateTime.now(),
      userAnswers: [
        UserAnswer(
          questionId: '1_1',
          selectedOptionIds: ['1_1_3'],
          isCorrect: true,
          timeSpent: 30,
        ),
        UserAnswer(
          questionId: '1_2',
          selectedOptionIds: ['1_2_4'],
          isCorrect: true,
          timeSpent: 25,
        ),
        UserAnswer(
          questionId: '1_3',
          selectedOptionIds: ['1_3_3'],
          isCorrect: true,
          timeSpent: 20,
        ),
        UserAnswer(
          questionId: '1_4',
          selectedOptionIds: ['1_4_1', '1_4_2'],
          isCorrect: false,
          timeSpent: 45,
        ),
        UserAnswer(
          questionId: '1_5',
          selectedOptionIds: ['1_5_2'],
          isCorrect: true,
          timeSpent: 15,
        ),
      ],
    );
  }
}