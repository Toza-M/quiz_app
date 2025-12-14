import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Use 10.0.2.2 for Android Emulator.
  // Use 'http://localhost:5000/auth' for iOS Simulator.
  // Use your computer's IP address for physical devices.
  static const String baseUrl = 'http://10.0.2.2:5000/auth';

  /// Register a new user
  static Future<Map<String, dynamic>> register(
    String fullName,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'full_name': fullName,
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        // According to your auth.py:
        // return jsonify({'message': 'user registered', 'token': token, 'user': created}), 201

        final token = data['token'];
        final user = data['user'];
        final name = user['full_name'];

        // Save session data locally
        await _saveUserData(token, name);

        return {'success': true, 'message': 'Registration successful'};
      } else {
        return {
          'success': false,
          'message': data['error'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  /// Login existing user
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // According to your auth.py:
        // return jsonify({'message': 'login successful', 'token': token, 'user': {'id': ... 'full_name': ...}}), 200

        final token = data['token'];
        final user = data['user'];
        final name = user['full_name'];

        // Save session data locally
        await _saveUserData(token, name);

        return {'success': true, 'user': user};
      } else {
        return {'success': false, 'message': data['error'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  /// Save token and user name to SharedPreferences
  static Future<void> _saveUserData(String token, String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('user_name', name);
  }

  /// Retrieve the auth token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  /// Retrieve the saved user name
  static Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name') ?? 'User';
  }

  /// Clear session data (Logout)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_name');
  }
}
