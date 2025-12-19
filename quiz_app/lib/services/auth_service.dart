<<<<<<< HEAD
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Use 127.0.0.1 for Chrome Web, 10.0.2.2 for Android Emulator
  static const String baseUrl = "http://127.0.0.1:5000/auth";
  static const String generateUrl = "http://127.0.0.1:5000/generate-quiz";

  // --- REGISTER (Static) ---
  static Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {'username': name, 'email': email, 'password': password}),
      );

      if (response.statusCode == 201) {
        return {'success': true, 'message': 'Registration successful'};
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['error'] ?? 'Registration failed'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  // --- LOGIN (Static) ---
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Save token
        if (data['user'] != null) {
          final prefs = await SharedPreferences.getInstance();
          // Assuming backend might send a token, or we just save login state
          await prefs.setBool('is_logged_in', true);
          await prefs.setString('user_data', jsonEncode(data['user']));
        }
        return {'success': true, 'message': 'Login successful', 'data': data};
      } else {
        return {'success': false, 'message': data['error'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  // --- LOGOUT (Static) ---
  // Call this method when the logout button is pressed
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Removes all saved data (tokens, user info)
  }

  // --- GENERATE QUIZ (Instance Method) ---
  // Used by GenerateQuizScreen
  Future<List<dynamic>> generateQuiz(
      List<int> fileBytes, String fileName) async {
    var request = http.MultipartRequest('POST', Uri.parse(generateUrl));

    request.files.add(http.MultipartFile.fromBytes(
      'file',
      fileBytes,
      filename: fileName,
    ));

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to generate quiz: ${response.body}");
    }
  }
}
=======
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Use 127.0.0.1 for Chrome Web, 10.0.2.2 for Android Emulator
  static const String baseUrl = "http://127.0.0.1:5000/auth";
  static const String generateUrl = "http://127.0.0.1:5000/generate-quiz";

  // --- REGISTER (Static) ---
  static Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {'username': name, 'email': email, 'password': password}),
      );

      if (response.statusCode == 201) {
        return {'success': true, 'message': 'Registration successful'};
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['error'] ?? 'Registration failed'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  // --- LOGIN (Static) ---
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Save token
        if (data['user'] != null) {
          final prefs = await SharedPreferences.getInstance();
          // Assuming backend might send a token, or we just save login state
          await prefs.setBool('is_logged_in', true);
          await prefs.setString('user_data', jsonEncode(data['user']));
        }
        return {'success': true, 'message': 'Login successful', 'data': data};
      } else {
        return {'success': false, 'message': data['error'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  // --- LOGOUT (Static) ---
  // Call this method when the logout button is pressed
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Removes all saved data (tokens, user info)
  }

  // --- GENERATE QUIZ (Instance Method) ---
  // Used by GenerateQuizScreen
  Future<List<dynamic>> generateQuiz(
      List<int> fileBytes, String fileName) async {
    var request = http.MultipartRequest('POST', Uri.parse(generateUrl));

    request.files.add(http.MultipartFile.fromBytes(
      'file',
      fileBytes,
      filename: fileName,
    ));

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to generate quiz: ${response.body}");
    }
  }
}
>>>>>>> 39aad75927553873c2f5c7249674e37404365eb7
