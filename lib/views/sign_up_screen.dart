import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rolebased_login/controller/auth_controller.dart';

class SignUpScreen extends StatelessWidget {
  final void Function()? onTap;

  SignUpScreen({super.key, required this.onTap});

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final RxString selectedRole = "".obs; // For tracking selected role

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
                    labelText: "Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),

                // Input for email
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),

                // Input for password
                Obx(() {
                  return TextField(
                    obscureText: !authController.showPassword.value,
                    controller: passController,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          authController.showPassword.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          authController.showPassword.value =
                              !authController.showPassword.value;
                        },
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 15),

                // Dropdown for role selection
                Obx(() {
                  return DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "Role",
                      border: OutlineInputBorder(),
                    ),
                    items: ["Admin", "User"].map((role) {
                      return DropdownMenuItem(
                        value: role.toLowerCase(),
                        child: Text(role),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      selectedRole.value = value!;
                    },
                    value: selectedRole.value.isNotEmpty
                        ? selectedRole.value
                        : null,
                  );
                }),
                const SizedBox(height: 15),

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

                // Register button
                Obx(() {
                  return authController.isLoading.value
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () async {
                            if (selectedRole.value.isEmpty) {
                              Get.snackbar(
                                "Role Selection",
                                "Please select a role to continue.",
                                snackPosition: SnackPosition.BOTTOM,
                              );
                              return;
                            }
                            await authController.signup(
                              emailController.text.trim(),
                              passController.text.trim(),
                              nameController.text.trim(),
                              selectedRole.value,
                            );

                            if (authController.errorMessage.value.isEmpty) {
                              Get.snackbar(
                                "Success",
                                "Account created successfully!",
                                snackPosition: SnackPosition.BOTTOM,
                              );
                              authController.errorMessage.value="";
                              // Redirect to login
                              onTap?.call();
                            }
                          },
                          child: const Text("Register"),
                        );
                }),
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
                      onTap: onTap,
                      child: const Text(
                        "Login here",
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
