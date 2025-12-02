import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter email and password'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await AuthService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (success) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login failed. Please check your credentials.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade600,
              Colors.purple.shade600,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'QuizApp',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Times New Roman',
                  ),
                ),
                const SizedBox(height: 80),

                // Email Field
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.email, color: Colors.grey),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                const SizedBox(height: 20),

                // Password Field
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      if (_emailController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter your email first'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        return;
                      }

                      try {
                        AuthService.sendPasswordResetEmail(
                            _emailController.text.trim());
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Password reset email sent! Check your inbox.'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to send reset email: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Times New Roman',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Sign In Button
                Container(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 2,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                        : const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Times New Roman',
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                // Or divider
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(color: Colors.white.withOpacity(0.5)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'or',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontFamily: 'Times New Roman',
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(color: Colors.white.withOpacity(0.5)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Social Login Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Google Login
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.g_mobiledata,
                            size: 20, color: Colors.black),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Google sign in coming soon!'),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 15),

                    // Apple Login
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.apple,
                            color: Colors.black, size: 20),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Apple sign in coming soon!'),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Don't have an account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Times New Roman',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.lightBlueAccent,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Times New Roman',
                        ),
                      ),
                    ),
                  ],
                ),

                // Test Firebase Button (Remove in production)
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Firebase Test',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Times New Roman',
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          print('Testing Firebase connection...');
                          final isLoggedIn = AuthService.isLoggedIn();
                          final userName = AuthService.getCurrentUser();
                          final userEmail = AuthService.getUserEmail();

                          if (isLoggedIn) {
                            print(
                                '✅ User is logged in: $userName ($userEmail)');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('User logged in: $userName'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            print('ℹ️ No user logged in');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('No user logged in'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.withOpacity(0.3),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Test Firebase Connection'),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Test with demo credentials
                          _emailController.text = 'test@example.com';
                          _passwordController.text = 'password123';
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Demo credentials filled. Click Sign In to test.'),
                              backgroundColor: Colors.blue,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.withOpacity(0.3),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Fill Demo Credentials'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
