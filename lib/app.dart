import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'presentation/screens/login/login_screen.dart';
import 'presentation/screens/main_wrapper.dart';

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QuizVerse',
      home: FirebaseAuth.instance.currentUser != null
          ? const MainWrapper()
          : const LoginScreen(),
    );
  }
}