import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../data/dummy_data.dart';
import '../models/quiz_model.dart';
import 'quiz_session_screen.dart';
import 'my_quizzes_screen.dart';
import 'generate_quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = 'User'; // Default name

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load User Data from JSON
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('user_data');

    if (userDataString != null) {
      final userData = jsonDecode(userDataString);
      setState(() {
        _userName = userData['username'] ?? 'User';
      });
    }
  }

  void _handleLogout() async {
    await AuthService.logout();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final quizzes = DummyData.getDummyQuizzes();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'QuizApp', // Kept generic title in AppBar since name is in body now
          style: TextStyle(
            fontFamily: 'Times New Roman',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. User Welcome Section (Gradient) ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue.shade600, Colors.purple.shade600],
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.person, size: 30, color: Colors.white),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- RESTORED NAME HERE ---
                        Text(
                          'Welcome back,',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                            fontFamily: 'Times New Roman',
                          ),
                        ),
                        Text(
                          _userName, // Showing the variable again
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22, // Made slightly bigger
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Times New Roman',
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Kept the Generate button as it's useful, but smaller
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const GenerateQuizScreen()),
                            );
                          },
                          icon: const Icon(Icons.auto_awesome, size: 14),
                          label: const Text("Create New Quiz"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // --- 2. Quizzes Section Header ---
            const Text(
              'Software Project Management Quizzes',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Times New Roman',
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Test your knowledge with these samples',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontFamily: 'Times New Roman',
              ),
            ),
            const SizedBox(height: 20),

            // --- 3. Quizzes List ---
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: quizzes.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: QuizCard(quiz: quizzes[index]),
                );
              },
            ),
          ],
        ),
      ),

      // --- Bottom Navigation Bar ---
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.auto_awesome), label: 'Generate'),
          BottomNavigationBarItem(
              icon: Icon(Icons.history), label: 'My Quizzes'),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const GenerateQuizScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyQuizzesScreen()),
            );
          }
        },
      ),
    );
  }
}

// --- Quiz Card Widget (Unchanged) ---
class QuizCard extends StatelessWidget {
  final Quiz quiz;

  const QuizCard({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.quiz, color: Colors.blue, size: 30),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quiz.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Times New Roman',
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    quiz.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontFamily: 'Times New Roman',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(quiz.difficulty),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          quiz.difficultyText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${quiz.questionCount} Qs',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${quiz.duration} min',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 35,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizSessionScreen(quiz: quiz),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: const Text('Start'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(double difficulty) {
    if (difficulty <= 2.0) return Colors.green;
    if (difficulty <= 3.5) return Colors.orange;
    return Colors.red;
  }
}
