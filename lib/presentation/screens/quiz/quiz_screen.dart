import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/services/api_service.dart';
import '../../../data/models/question_model.dart';
import '../../widgets/option_card.dart';
import '../result/result_screen.dart';

class QuizScreen extends StatefulWidget {
  final int categoryId;

  const QuizScreen({
    super.key,
    required this.categoryId,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final ApiService _apiService = ApiService();

  List<QuestionModel> _questions = [];

  bool _isLoading = true;
  String? _errorMessage;

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
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final questions = await _apiService.getQuestions(widget.categoryId);

      if (!mounted) return;

      setState(() {
        _questions = questions;
        _isLoading = false;
      });

      _startTimer();
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage =
            'Unable to load quiz questions. Please check your internet connection and try again.';
      });
    }
  }

  void _startTimer() {
    _timer?.cancel();

    _remainingSeconds = 30;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (!mounted) return;

        if (_remainingSeconds > 0) {
          setState(() {
            _remainingSeconds--;
          });
        } else {
          _nextQuestion();
        }
      },
    );
  }

  void _nextQuestion() {
    _timer?.cancel();

    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswerIndex = null;
      });

      _startTimer();
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
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
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF6F7FB),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF6F7FB),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.wifi_off,
                  size: 72,
                  color: Color(0xFF4F46E5),
                ),
                const SizedBox(height: 24),
                const Text(
                  'No Internet Connection',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _loadQuestions,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Retry',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final question = _questions[_currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),

        title: Text(
          "Question ${_currentIndex + 1}/${_questions.length}",
          style: const TextStyle(
            color: Color(0xFF111827),
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE9FE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${_remainingSeconds}s",
                  style: const TextStyle(
                    color: Color(0xFF4F46E5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            LinearProgressIndicator(
              value:
                  (_currentIndex + 1) /
                      _questions.length,
              minHeight: 7,
              borderRadius: BorderRadius.circular(10),
              backgroundColor: Colors.grey.shade300,
              valueColor:
                  const AlwaysStoppedAnimation(
                Color(0xFF4F46E5),
              ),
            ),

            const SizedBox(height: 28),

            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(22),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(20),

                boxShadow: [
                  BoxShadow(
                    color:
                        Colors.black.withOpacity(.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),

              child: Text(
                question.question,

                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
            ),

            const SizedBox(height: 26),

            Expanded(
              child: ListView.builder(
                itemCount: question.options.length,

                itemBuilder: (context, index) {
                  return OptionCard(
                    text: question.options[index],

                    isSelected:
                        _selectedAnswerIndex == index,

                    onTap: () {
                      setState(() {
                        _selectedAnswerIndex =
                            index;
                      });
                    },
                  );
                },
              ),
            ),

            SizedBox(
              width: double.infinity,
              height: 56,

              child: ElevatedButton(
                onPressed:
                    _selectedAnswerIndex == null
                        ? null
                        : () {
                            if (_selectedAnswerIndex ==
                                question.answerIndex) {
                              _score += question.mark;
                            }

                            _nextQuestion();
                          },

                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF4F46E5),

                  foregroundColor: Colors.white,

                  disabledBackgroundColor:
                      Colors.grey.shade300,

                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                ),

                child: Text(
                  _currentIndex ==
                          _questions.length - 1
                      ? "Finish Quiz"
                      : "Next Question",

                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}