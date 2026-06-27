import 'package:flutter/material.dart';

import 'presentation/screens/main_wrapper.dart';

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QuizVerse',
      home: const MainWrapper(),
    );
  }
}