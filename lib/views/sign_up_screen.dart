import 'package:flutter/material.dart';
import 'package:rolebased_login/service/auth/auth_service.dart';
import 'package:rolebased_login/views/componets/my_button.dart';

class SignUpScreen extends StatefulWidget {
  final void Function()? onTap;

  const SignUpScreen({super.key, required this.onTap});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  String? selectedRole;
  final AuthService _authService = AuthService();
  String? errorMessage;
  bool isLoading = false;

  /// Signup logic
  Future<void> _handleSignup() async {
    final email = emailController.text.trim();
    final password = passController.text.trim();
    final name = nameController.text.trim();

    if (email.isEmpty || password.isEmpty || name.isEmpty || selectedRole == null) {
      setState(() {
        errorMessage = "All fields are required.";
      });
      return;
    }

    if (password.length < 6) {
      setState(() {
        errorMessage = "Password must be at least 6 characters long.";
      });
      return;
    }

    setState(() {
      errorMessage = null;
      isLoading = true;
    });

    try {
      await _authService.signInWithEmailPassword(email, password, name, selectedRole!);
      // Successfully registered
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created successfully!")),
      );

      // Navigate back to the login screen
      widget.onTap?.call();
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
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
    passController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Image
                Image.network(
                  "https://img.freepik.com/premium-vector/register-access-login-password-internet-online-website-concept-flat-illustration_385073-108.jpg?semt=ais_hybrid",
                  height: 250,
                ),
                const SizedBox(height: 20),

                // Input for name
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      labelText: "Name", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 15),

                // Input for email
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      labelText: "Email", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 15),

                // Input for password
                TextField(
                  obscureText: true,
                  controller: passController,
                  decoration: const InputDecoration(
                      labelText: "Password", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),

                // Dropdown for role selection
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                      labelText: "Role", border: OutlineInputBorder()),
                  items: ["Admin", "User"].map((role) {
                    return DropdownMenuItem(child: Text(role), value: role);
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedRole = newValue;
                    });
                  },
                ),
                const SizedBox(height: 10),

                // Error message
                if (errorMessage != null)
                  Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 15),

                // Register button
                isLoading
                    ? const CircularProgressIndicator()
                    : MyButton(
                        buttonName: "Register",
                        onTap: _handleSignup,
                      ),
                const SizedBox(height: 10),

                // Login prompt
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Login here",
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
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
