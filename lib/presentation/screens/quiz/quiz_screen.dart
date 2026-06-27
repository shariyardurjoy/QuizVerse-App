import 'dart:async';
import 'package:flutter/material.dart';
import '../../widgets/option_card.dart';
import '../../../data/models/question_model.dart';
import '../../../core/services/api_service.dart';
import '../result/result_screen.dart';

class QuizScreen extends StatefulWidget {
  final int categoryId;
  const QuizScreen({Key? key, required this.categoryId}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final ApiService _apiService = ApiService();
  List<QuestionModel> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedAnswerIndex;
  Timer? _timer;
  int _remainingSeconds = 30;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final questions = await _apiService.getQuestions(widget.categoryId);
    setState(() {
      _questions = questions;
      _startTimer();
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        _nextQuestion();
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _remainingSeconds = 30;
        _selectedAnswerIndex = null;
      });
    } else {
      _timer?.cancel();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            score: _score,
            totalQuestions: _questions.length,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    
    final question = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(title: Text("Time: $_remainingSeconds")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(question.question, style: const TextStyle(fontSize: 20)),
            ...question.options.asMap().entries.map((entry) {
              return OptionCard(
                text: entry.value,
                isSelected: _selectedAnswerIndex == entry.key,
                onTap: () => setState(() => _selectedAnswerIndex = entry.key),
              );
            }).toList(),
            ElevatedButton(
              onPressed: () {
                if (_selectedAnswerIndex == question.answerIndex) _score += question.mark;
                _nextQuestion();
              },
              child: const Text("Next"),
            )
          ],
        ),
      ),
    );
  }
}