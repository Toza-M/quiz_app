import '../models/quiz_model.dart';

class DummyData {
  static List<Quiz> getDummyQuizzes() {
    return [
      Quiz(
        id: '1',
        title: 'Project Initiation',
        description:
            'Basics of starting a software project and feasibility studies.',
        difficulty: 1.5,
        duration: 10,
        questions: [
          Question(
            id: 'q1',
            text: 'Which document formally authorizes a project?',
            options: [
              'Project Charter',
              'Business Case',
              'Scope Statement',
              'WBS'
            ],
            correctAnswerIndex: 0, // Option 0: Project Charter
          ),
          Question(
            id: 'q2',
            text: 'Who is responsible for the project success?',
            options: [
              'Project Manager',
              'Stakeholders',
              'Project Sponsor',
              'Team Members'
            ],
            correctAnswerIndex: 0, // Option 0: Project Manager
          ),
        ],
      ),
      Quiz(
        id: '2',
        title: 'Agile Methodology',
        description: 'Scrum, Kanban and iterative development concepts.',
        difficulty: 3.0,
        duration: 15,
        questions: [
          Question(
            id: 'q3',
            text: 'What is the duration of a Sprint in Scrum usually?',
            options: ['1-4 Weeks', '1-2 Days', '3-6 Months', 'Variable'],
            correctAnswerIndex: 0,
          ),
          Question(
            id: 'q4',
            text: 'Who manages the Product Backlog?',
            options: [
              'Scrum Master',
              'Product Owner',
              'Development Team',
              'CEO'
            ],
            correctAnswerIndex: 1,
          ),
          Question(
            id: 'q5',
            text:
                'Which meeting is held at the end of a sprint to inspect the increment?',
            options: [
              'Sprint Planning',
              'Daily Standup',
              'Sprint Review',
              'Sprint Retrospective'
            ],
            correctAnswerIndex: 2,
          ),
        ],
      ),
      Quiz(
        id: '3',
        title: 'Risk Management',
        description: 'Identifying, analyzing and responding to project risks.',
        difficulty: 4.5,
        duration: 20,
        questions: [
          Question(
            id: 'q6',
            text: 'What is the first step in Risk Management?',
            options: [
              'Risk Analysis',
              'Risk Response Planning',
              'Risk Identification',
              'Risk Monitoring'
            ],
            correctAnswerIndex: 2,
          ),
          Question(
            id: 'q7',
            text: 'A risk that has a positive impact is called:',
            options: ['Threat', 'Issue', 'Opportunity', 'Hazard'],
            correctAnswerIndex: 2,
          ),
        ],
      ),
    ];
  }
}
