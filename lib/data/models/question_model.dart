class QuestionModel {
  final int id;
  final String question;
  final List<String> options;
  final int answerIndex;
  final int mark;

  QuestionModel({
    required this.id,
    required this.question,
    required this.options,
    required this.answerIndex,
    required this.mark,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      question: json['question'],
      // Safely parse the list of strings
      options: List<String>.from(json['options'] ?? []),
      answerIndex: json['answerIndex'] ?? 0,
      mark: json['mark'] ?? 10,
    );
  }
}