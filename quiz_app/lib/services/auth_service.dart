import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // 1. Private Constructor
  AuthService._privateConstructor();

  // 2. Single static instance
  static final AuthService _instance = AuthService._privateConstructor();

  // 3. Factory constructor to return the instance
  factory AuthService() {
    return _instance;
  }

  static const String baseUrl = "http://127.0.0.1:5000/auth";
  static const String generateUrl = "http://127.0.0.1:5000/generate-quiz";

  // Cache user data in the Singleton state
  Map<String, dynamic>? _currentUser;
  Map<String, dynamic>? get currentUser => _currentUser;

  Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {'username': name, 'email': email, 'password': password}),
      );
      return response.statusCode == 201
          ? {'success': true, 'message': 'Success'}
          : {'success': false, 'message': jsonDecode(response.body)['error']};
    } catch (e) {
      return {'success': false, 'message': 'Network Error'};
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _currentUser = data['user']; // Store in Singleton memory
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_logged_in', true);
        await prefs.setString('user_data', jsonEncode(data['user']));
        return {'success': true, 'data': data};
      }
      return {'success': false, 'message': data['error']};
    } catch (e) {
      return {'success': false, 'message': 'Connection error'};
    }
  }

  Future<void> logout() async {
    _currentUser = null; // Clear Singleton state
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<List<dynamic>> generateQuiz(
      List<int> fileBytes, String fileName) async {
    var request = http.MultipartRequest('POST', Uri.parse(generateUrl));
    request.files.add(
        http.MultipartFile.fromBytes('file', fileBytes, filename: fileName));
    var response = await http.Response.fromStream(await request.send());
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception("Generation failed");
  }
}
