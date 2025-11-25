import '../models/quiz_model.dart';

class DummyData {
  static List<Quiz> getDummyQuizzes() {
    return [
      Quiz(
        id: '1',
        title: 'SW Project Management - Quiz 1',
        description: 'Basic concepts and project fundamentals',
        category: 'Software Engineering',
        imageUrl: 'assets/images/quiz1.jpg',
        questionCount: 5,
        duration: 10,
        difficulty: 2.0,
        createdAt: DateTime(2024, 1, 15),
        questions: [
          Question(
            id: '1_1',
            questionText: 'What is the primary definition of a project according to PMBOK?',
            type: QuestionType.singleChoice,
            explanation: 'A project is "a temporary endeavor undertaken to create a unique product, service, or result" according to PMBOK Guide.',
            options: [
              Option(id: '1_1_1', text: 'A permanent organizational structure', isCorrect: false),
              Option(id: '1_1_2', text: 'A temporary endeavor to create unique outcomes', isCorrect: true),
              Option(id: '1_1_3', text: 'A routine operational activity', isCorrect: false),
              Option(id: '1_1_4', text: 'A financial investment plan', isCorrect: false),
            ],
          ),
          Question(
            id: '1_2',
            questionText: 'Which of the following is NOT a key attribute of a project?',
            type: QuestionType.singleChoice,
            explanation: 'Projects are temporary, have unique purposes, drive change, and involve uncertainty. They are not permanent operations.',
            options: [
              Option(id: '1_2_1', text: 'Unique purpose', isCorrect: false),
              Option(id: '1_2_2', text: 'Temporary nature', isCorrect: false),
              Option(id: '1_2_3', text: 'Permanent organizational structure', isCorrect: true),
              Option(id: '1_2_4', text: 'Involves uncertainty', isCorrect: false),
            ],
          ),
          Question(
            id: '1_3',
            questionText: 'What is the main difference between a project and a program?',
            type: QuestionType.singleChoice,
            explanation: 'A program is a group of related projects coordinated to harness synergies, while a project is a single planned undertaking.',
            options: [
              Option(id: '1_3_1', text: 'Programs are temporary, projects are permanent', isCorrect: false),
              Option(id: '1_3_2', text: 'Programs coordinate related projects for synergies', isCorrect: true),
              Option(id: '1_3_3', text: 'Projects are larger than programs', isCorrect: false),
              Option(id: '1_3_4', text: 'Programs don\'t have sponsors', isCorrect: false),
            ],
          ),
          Question(
            id: '1_4',
            questionText: 'What are the three main constraints in project management?',
            type: QuestionType.singleChoice,
            explanation: 'The triple constraint includes scope, time, and cost - these must be balanced for project success.',
            options: [
              Option(id: '1_4_1', text: 'Scope, Time, Cost', isCorrect: true),
              Option(id: '1_4_2', text: 'Quality, Risk, Resources', isCorrect: false),
              Option(id: '1_4_3', text: 'Team, Budget, Schedule', isCorrect: false),
              Option(id: '1_4_4', text: 'Stakeholders, Sponsors, Customers', isCorrect: false),
            ],
          ),
          Question(
            id: '1_5',
            questionText: 'Which of these is a unique feature of software projects?',
            type: QuestionType.singleChoice,
            explanation: 'Software projects face changing technological contexts, making them more challenging than traditional projects.',
            options: [
              Option(id: '1_5_1', text: 'Fixed technological requirements', isCorrect: false),
              Option(id: '1_5_2', text: 'Changing technological context', isCorrect: true),
              Option(id: '1_5_3', text: 'Predictable user requirements', isCorrect: false),
              Option(id: '1_5_4', text: 'Stable project scope', isCorrect: false),
            ],
          ),
        ],
      ),
      Quiz(
        id: '2',
        title: 'SW Project Management - Quiz 2',
        description: 'Advanced concepts and project success factors',
        category: 'Software Engineering',
        imageUrl: 'assets/images/quiz2.jpg',
        questionCount: 5,
        duration: 10,
        difficulty: 3.0,
        createdAt: DateTime(2024, 1, 20),
        questions: [
          Question(
            id: '2_1',
            questionText: 'According to research, what percentage of software projects were successful in 2015?',
            type: QuestionType.singleChoice,
            explanation: 'The Standish Group reported that only 29% of software projects were successfully completed in 2015.',
            options: [
              Option(id: '2_1_1', text: '29%', isCorrect: true),
              Option(id: '2_1_2', text: '50%', isCorrect: false),
              Option(id: '2_1_3', text: '75%', isCorrect: false),
              Option(id: '2_1_4', text: '15%', isCorrect: false),
            ],
          ),
          Question(
            id: '2_2',
            questionText: 'Which project methodology showed higher success rates according to Standish Group?',
            type: QuestionType.singleChoice,
            explanation: 'Agile projects had 39% success rate compared to 11% for waterfall projects.',
            options: [
              Option(id: '2_2_1', text: 'Waterfall methodology', isCorrect: false),
              Option(id: '2_2_2', text: 'Agile methodology', isCorrect: true),
              Option(id: '2_2_3', text: 'Spiral methodology', isCorrect: false),
              Option(id: '2_2_4', text: 'V-model methodology', isCorrect: false),
            ],
          ),
          Question(
            id: '2_3',
            questionText: 'What is the primary role of a project manager?',
            type: QuestionType.singleChoice,
            explanation: 'Project managers apply knowledge, skills, tools and techniques to meet project requirements and satisfy stakeholders.',
            options: [
              Option(id: '2_3_1', text: 'Only to manage the budget', isCorrect: false),
              Option(id: '2_3_2', text: 'To write code for the project', isCorrect: false),
              Option(id: '2_3_3', text: 'Apply knowledge and skills to meet project requirements', isCorrect: true),
              Option(id: '2_3_4', text: 'Only to report to senior management', isCorrect: false),
            ],
          ),
          Question(
            id: '2_4',
            questionText: 'Which of these is a key success factor for software projects?',
            type: QuestionType.singleChoice,
            explanation: 'User involvement is consistently identified as a critical success factor for software projects.',
            options: [
              Option(id: '2_4_1', text: 'Lack of user involvement', isCorrect: false),
              Option(id: '2_4_2', text: 'User involvement', isCorrect: true),
              Option(id: '2_4_3', text: 'Unrealistic expectations', isCorrect: false),
              Option(id: '2_4_4', text: 'Incomplete requirements', isCorrect: false),
            ],
          ),
          Question(
            id: '2_5',
            questionText: 'What are the five process groups in project management?',
            type: QuestionType.singleChoice,
            explanation: 'The five process groups are: Initiating, Planning, Executing, Monitoring & Controlling, and Closing.',
            options: [
              Option(id: '2_5_1', text: 'Initiating, Planning, Executing, Monitoring, Closing', isCorrect: true),
              Option(id: '2_5_2', text: 'Starting, Doing, Finishing, Reviewing, Reporting', isCorrect: false),
              Option(id: '2_5_3', text: 'Analysis, Design, Development, Testing, Deployment', isCorrect: false),
              Option(id: '2_5_4', text: 'Budgeting, Scheduling, Resourcing, Controlling, Delivering', isCorrect: false),
            ],
          ),
        ],
      ),
    ];
  }

  // ... keep the existing getDummyUserProfile() and getDummyQuizAttempt() methods
}