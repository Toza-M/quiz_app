class AuthService {
  // Simple dummy authentication
  static bool login(String email, String password) {
    // For prototype, accept any email/password or use dummy credentials
    return email.isNotEmpty && password.isNotEmpty;
  }
  
  static String getCurrentUser() {
    return 'Rody'; // Updated to Rody
  }
  
  static String getUserEmail() {
    return 'Rody@gmail.com'; // Updated to Rody's email
  }
}