import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static late FirebaseAuth _auth;
  static late FirebaseFirestore _firestore;

  // Initialize Firebase
  static Future<void> initialize() async {
    await Firebase.initializeApp();
    _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
    print('✅ Firebase initialized successfully');
  }

  // Get instances
  static FirebaseAuth get auth => _auth;
  static FirebaseFirestore get firestore => _firestore;
}
