import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_service.dart';

class AuthService {
  // Real Firebase login
  static Future<bool> login(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseService.auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      print('✅ User logged in: ${userCredential.user!.email}');
      return true;
    } on FirebaseAuthException catch (e) {
      print('❌ Login error: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      print('❌ Unexpected login error: $e');
      return false;
    }
  }

  // Real Firebase registration
  static Future<bool> register(
      String fullName, String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseService.auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Save additional user info to Firestore
      await _saveUserProfile(
        uid: userCredential.user!.uid,
        email: email.trim(),
        displayName: fullName.trim(),
      );

      print('✅ User registered: ${userCredential.user!.email}');
      return true;
    } on FirebaseAuthException catch (e) {
      print('❌ Registration error: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      print('❌ Unexpected registration error: $e');
      return false;
    }
  }

  // Save user profile to Firestore
  static Future<void> _saveUserProfile({
    required String uid,
    required String email,
    required String displayName,
  }) async {
    try {
      await FirebaseService.firestore.collection('users').doc(uid).set({
        'uid': uid,
        'email': email,
        'displayName': displayName,
        'totalQuizzesTaken': 0,
        'totalCorrectAnswers': 0,
        'totalQuestionsAttempted': 0,
        'averageScore': 0.0,
        'joinedAt': Timestamp.now(),
      });
      print('✅ User profile saved to Firestore');
    } catch (e) {
      print('❌ Error saving user profile: $e');
      rethrow;
    }
  }

  // Get current user display name
  static String getCurrentUser() {
    final user = FirebaseService.auth.currentUser;
    if (user != null) {
      return user.displayName ?? user.email?.split('@').first ?? 'User';
    }
    return 'Guest';
  }

  // Get current user email
  static String? getUserEmail() {
    return FirebaseService.auth.currentUser?.email;
  }

  // Get current user ID
  static String? getUserId() {
    return FirebaseService.auth.currentUser?.uid;
  }

  // Check if user is logged in
  static bool isLoggedIn() {
    return FirebaseService.auth.currentUser != null;
  }

  // Logout
  static Future<void> logout() async {
    try {
      await FirebaseService.auth.signOut();
      print('✅ User logged out');
    } catch (e) {
      print('❌ Error logging out: $e');
      rethrow;
    }
  }

  // Send password reset email
  static Future<void> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseService.auth.sendPasswordResetEmail(email: email.trim());
      print('✅ Password reset email sent to $email');
    } on FirebaseAuthException catch (e) {
      print('❌ Password reset error: ${e.code} - ${e.message}');
      rethrow;
    }
  }

  // Update user profile
  static Future<void> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      final user = FirebaseService.auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(displayName);
        if (photoURL != null) {
          await user.updatePhotoURL(photoURL);
        }

        // Also update in Firestore
        await FirebaseService.firestore
            .collection('users')
            .doc(user.uid)
            .update({
          if (displayName != null) 'displayName': displayName,
          if (photoURL != null) 'photoURL': photoURL,
          'updatedAt': Timestamp.now(),
        });

        print('✅ User profile updated');
      }
    } catch (e) {
      print('❌ Error updating profile: $e');
      rethrow;
    }
  }

  // Get current Firebase User object
  static User? getFirebaseUser() {
    return FirebaseService.auth.currentUser;
  }

  // Get user data from Firestore
  static Future<Map<String, dynamic>?> getUserData() async {
    try {
      final user = getFirebaseUser();
      if (user != null) {
        final doc = await FirebaseService.firestore
            .collection('users')
            .doc(user.uid)
            .get();

        if (doc.exists) {
          return doc.data();
        }
      }
      return null;
    } catch (e) {
      print('❌ Error getting user data: $e');
      return null;
    }
  }

  // Update user statistics after quiz completion
  static Future<void> updateUserStats({
    required int correctAnswers,
    required int totalQuestions,
  }) async {
    try {
      final user = getFirebaseUser();
      if (user != null) {
        final userRef =
            FirebaseService.firestore.collection('users').doc(user.uid);

        // Get current data
        final doc = await userRef.get();
        final data = doc.data() ?? {};

        final currentQuizzes = (data['totalQuizzesTaken'] ?? 0) + 1;
        final currentCorrect =
            (data['totalCorrectAnswers'] ?? 0) + correctAnswers;
        final currentAttempted =
            (data['totalQuestionsAttempted'] ?? 0) + totalQuestions;

        // Calculate new average
        final currentAvg = (data['averageScore'] ?? 0.0).toDouble();
        final newScore = (correctAnswers / totalQuestions) * 100;
        final newAvg = currentQuizzes == 1
            ? newScore
            : ((currentAvg * (currentQuizzes - 1)) + newScore) / currentQuizzes;

        // Update document
        await userRef.update({
          'totalQuizzesTaken': currentQuizzes,
          'totalCorrectAnswers': currentCorrect,
          'totalQuestionsAttempted': currentAttempted,
          'averageScore': newAvg,
          'lastQuizAt': Timestamp.now(),
        });

        print('✅ User statistics updated');
      }
    } catch (e) {
      print('❌ Error updating user stats: $e');
    }
  }

  // Check if email is verified
  static bool isEmailVerified() {
    return FirebaseService.auth.currentUser?.emailVerified ?? false;
  }

  // Send email verification
  static Future<void> sendEmailVerification() async {
    try {
      final user = FirebaseService.auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        print('✅ Verification email sent');
      }
    } catch (e) {
      print('❌ Error sending verification email: $e');
      rethrow;
    }
  }

  // Reload user (to refresh email verification status)
  static Future<void> reloadUser() async {
    try {
      final user = FirebaseService.auth.currentUser;
      if (user != null) {
        await user.reload();
      }
    } catch (e) {
      print('❌ Error reloading user: $e');
      rethrow;
    }
  }

  // Get user's total quizzes taken
  static Future<int> getTotalQuizzesTaken() async {
    try {
      final userData = await getUserData();
      return (userData?['totalQuizzesTaken'] ?? 0) as int;
    } catch (e) {
      print('❌ Error getting total quizzes: $e');
      return 0;
    }
  }

  // Get user's average score
  static Future<double> getAverageScore() async {
    try {
      final userData = await getUserData();
      return (userData?['averageScore'] ?? 0.0) as double;
    } catch (e) {
      print('❌ Error getting average score: $e');
      return 0.0;
    }
  }

  // Get user's success rate
  static Future<double> getSuccessRate() async {
    try {
      final userData = await getUserData();
      final attempted = (userData?['totalQuestionsAttempted'] ?? 0) as int;
      final correct = (userData?['totalCorrectAnswers'] ?? 0) as int;

      if (attempted == 0) return 0.0;
      return (correct / attempted) * 100;
    } catch (e) {
      print('❌ Error getting success rate: $e');
      return 0.0;
    }
  }

  // Check if user exists in Firestore
  static Future<bool> userExistsInFirestore(String uid) async {
    try {
      final doc =
          await FirebaseService.firestore.collection('users').doc(uid).get();
      return doc.exists;
    } catch (e) {
      print('❌ Error checking user existence: $e');
      return false;
    }
  }

  // Create user in Firestore if doesn't exist (for existing Firebase users)
  static Future<void> ensureUserInFirestore() async {
    try {
      final user = getFirebaseUser();
      if (user != null) {
        final exists = await userExistsInFirestore(user.uid);
        if (!exists) {
          await _saveUserProfile(
            uid: user.uid,
            email: user.email ?? '',
            displayName:
                user.displayName ?? user.email?.split('@').first ?? 'User',
          );
        }
      }
    } catch (e) {
      print('❌ Error ensuring user in Firestore: $e');
    }
  }
}
