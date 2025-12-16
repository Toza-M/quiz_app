import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // ---------------------------------------------------------
  // IMPORTANT: Choose the correct URL for your emulator/device
  // ---------------------------------------------------------

  // Option A: For Web (Chrome) or iOS Simulator:
  static const String baseUrl = 'http://127.0.0.1:5000/auth';

  // Option B: For Android Emulator (Standard):
  // static const String baseUrl = 'http://10.0.2.2:5000/auth';

  // Option C: For Physical Phone (Replace with your PC's IP):
  // static const String baseUrl = 'http://192.168.1.5:5000/auth';

  // --- Register Method (This was missing!) ---
  static Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'full_name': name,
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        // Save token and name locally
        await _saveUserData(data['token'], data['user']['full_name']);
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

  // --- Login Method ---
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
        await _saveUserData(data['token'], data['user']['full_name']);
        return {'success': true, 'message': 'Login successful'};
      } else {
        return {'success': false, 'message': data['error'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  // --- Logout Method ---
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // --- Helper to save data ---
  static Future<void> _saveUserData(String token, String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('user_name', name);
  }
}
