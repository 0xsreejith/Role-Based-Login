import 'package:flutter/material.dart';
import 'package:rolebased_login/views/login_screen.dart';
import 'package:rolebased_login/views/sign_up_screen.dart';

class LoginOrSignup extends StatefulWidget {
  const LoginOrSignup({super.key});

  @override
  State<LoginOrSignup> createState() => _LoginOrSignupState();
}

class _LoginOrSignupState extends State<LoginOrSignup> {
  bool showLogin = true;
  void togglePage() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLogin) {
      return LoginScreen(onTap: togglePage);
    } else {
      return SignUpScreen(onTap: togglePage);
    }
  }
}
