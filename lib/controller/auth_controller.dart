import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/state_manager.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var showPassword = false.obs;
  var errorMessage = "".obs;
  var currentUser = Rx<User?>(null);
  var userRole = "".obs; // To store user role (admin/user)
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      //fetch user data from firestore
      DocumentSnapshot<Map<String, dynamic>> userDoc = await _firestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .get();
      if (userDoc.exists) {
        userRole.value = userDoc['role'];
        currentUser.value = userCredential.user;
      } else {
        errorMessage.value = "User not found in Firestore!";
        _auth.signOut();
      }
    } on FirebaseAuthException catch (e) {
      errorMessage.value = "Login failed: ${e.message}";
    } catch (e) {
      errorMessage.value = "Unknown error: ${e.toString()}";
    } finally {
      isLoading.value = false;
    }
  }

  // Function for Signup
  Future<void> signup(
      String email, String password, String name, String role) async {
    isLoading.value = true;
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Save user data in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'role': role,
      });
      // Update currentUser and userRole
      currentUser.value = userCredential.user;
      userRole.value = role;
    } on FirebaseAuthException catch (e) {
      errorMessage.value = "Signup failed: ${e.message}";
    } catch (e) {
      errorMessage.value = "Unknown error: ${e.toString()}";
    } finally {
      isLoading.value = false;
    }
  }

  // Function for checking user role
  String getRole() {
    return userRole.value;
  }

  // Function to logout
  Future<void> logout() async {
    await _auth.signOut();
    currentUser.value = null;
    userRole.value = '';
  }
}
