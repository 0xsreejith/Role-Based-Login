
import 'package:flutter/material.dart';
import 'package:rolebased_login/service/auth/auth_gate.dart';
import 'package:rolebased_login/service/auth/login_or_signup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: LoginOrSignup());
  }
}
