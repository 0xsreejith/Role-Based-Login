import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rolebased_login/service/auth/auth_service.dart';
import 'package:rolebased_login/views/admin_home_page.dart';
import 'package:rolebased_login/views/componets/my_button.dart';
import 'package:rolebased_login/views/home_page.dart';

class LoginScreen extends StatefulWidget {
  final void Function()? onTap; // Function for navigating to the signup screen

  const LoginScreen({super.key, required this.onTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  String? errorMessage;
  bool isLoading = false;
  bool isPasswordHidden = true;

  /// Login logic
Future<void> _handleLogin() async {
  final email = emailController.text.trim();
  final password = passwordController.text.trim();

  if (email.isEmpty || password.isEmpty) {
    setState(() {
      errorMessage = "Please enter both email and password.";
    });
    return;
  }

  setState(() {
    errorMessage = null;
    isLoading = true;
  });

  try {
    final result = await _authService.loginWithEmailPassword(email, password);

    // Extract role from the result
    final role = result['role'];

    // Check role and navigate accordingly
    if (role == 'admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminHomePage()), // Replace with admin page
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  } catch (e) {
    setState(() {
      errorMessage = "Login failed: ${e.toString()}";
    });
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),

                // Login illustration
                Image.network(
                  "https://img.freepik.com/free-vector/login-concept-illustration_114360-739.jpg",
                  height: 200,
                ),
                const SizedBox(height: 30),

                // Email input field
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 15),

                // Password input field
                TextField(
                  controller: passwordController,
                  obscureText: isPasswordHidden,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordHidden ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordHidden = !isPasswordHidden;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Error message
                if (errorMessage != null)
                  Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 15),

                // Login button with loading indicator
                isLoading
                    ? const CircularProgressIndicator()
                    : MyButton(
                        buttonName: "Login",
                        onTap: _handleLogin,
                      ),
                const SizedBox(height: 20),

                // Signup prompt
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Signup here",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
