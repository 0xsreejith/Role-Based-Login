import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rolebased_login/controller/auth_controller.dart';
import 'package:rolebased_login/service/auth/login_or_signup.dart';
import 'package:rolebased_login/views/login_screen.dart';

class HomePage extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authController.logout();
              // Navigate back to login screen after logout
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(
                    onTap: () {
                      // Handle navigation to signup
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Obx(() {
          final user = authController.currentUser.value;
          final role = authController.userRole.value;

          if (user == null) {
            return const Text(
              "No user logged in",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            );
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome, ${user.email}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "Role: $role",
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () async {
                  await authController.logout();
                  // Navigate back to login screen after logout
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginOrSignup(),
                    ),
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
              ),
            ],
          );
        }),
      ),
    );
  }
}
