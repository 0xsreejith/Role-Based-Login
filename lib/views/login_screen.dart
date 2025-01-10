import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rolebased_login/controller/auth_controller.dart';
import 'package:rolebased_login/views/componets/my_button.dart';
import 'package:rolebased_login/views/home_page.dart';

class LoginScreen extends StatelessWidget {
  final void Function()? onTap; // Function for navigating to the signup screen
  final AuthController authController = Get.put(AuthController());

  LoginScreen({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

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
                Obx(() {
                  return TextField(
                    controller: passwordController,
                    obscureText: authController.showPassword.value,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          authController.showPassword.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          authController.isLoading.value =
                              !authController.isLoading.value;
                        },
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 10),

                // Error message
                Obx(() {
                  return authController.errorMessage.value.isNotEmpty
                      ? Text(
                          authController.errorMessage.value,
                          style: const TextStyle(color: Colors.red),
                        )
                      : const SizedBox.shrink();
                }),
                const SizedBox(height: 15),

                // Login button with loading indicator
                Obx(() {
                  return authController.isLoading.value
                      ? const CircularProgressIndicator()
                      : MyButton(
                          buttonName: "Login",
                          onTap: () async {
                            await authController.login(
                              emailController.text.trim(),
                              passwordController.text.trim(),
                            );

                            // Navigate based on role
                            if (authController.currentUser.value != null) {
                              if (authController.getRole() == 'admin') {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(),
                                  ),
                                );
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(),
                                  ),
                                );
                              }
                            }
                          },
                        );
                }),
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
                      onTap: onTap,
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
