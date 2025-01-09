import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// For signup
  Future<UserCredential> signInWithEmailPassword(
      String email, String password, String name, String role) async {
    email = email.trim(); // Trim email once
    password = password.trim(); // Trim password if needed

    try {
      // Create user with email and password
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Save user data in Firestore
      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'role': role, // Role determines if user is admin or normal user
      });

      return userCredential; // Return user info
    } on FirebaseAuthException catch (e) {
      throw Exception("Auth Error: ${e.code}");
    } catch (e) {
      throw Exception("Unknown Error: ${e.toString()}");
    }
  }

  /// For login
  Future<Map<String, dynamic>> loginWithEmailPassword(
      String email, String password) async {
    email = email.trim(); // Trim email once
    password = password.trim(); // Trim password if needed

    try {
      // Sign in user with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // Fetch the user info from Firestore
      DocumentSnapshot<Map<String, dynamic>> userDoc = await _firestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception("User data not found in Firestore");
      }

      // Extract the user data and role
      Map<String, dynamic>? userData = userDoc.data();
      String role =
          userData?['role'] ?? 'user'; // Default to 'user' if no role is set

      // Return both user credential and Firestore user data, including role
      return {
        'userCredential': userCredential,
        'userData': userData,
        'role': role, // Add role in the returned data
      };
    } on FirebaseAuthException catch (e) {
      throw Exception("Auth Error: ${e.code}");
    } catch (e) {
      throw Exception("Unknown Error: ${e.toString()}");
    }
  }
}
