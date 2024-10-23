class FillTheGapQuestion {
  final int id;
  final String questionText; // Renamed to keep consistency with `Question` model
  final String correctAnswer;

  FillTheGapQuestion({
    required this.id,
    required this.questionText,
    required this.correctAnswer,
  });

  factory FillTheGapQuestion.fromMap(Map<String, dynamic> map) {
    return FillTheGapQuestion(
      id: map['ftg_id'],
      questionText: map['ftg_text'], // Ensure this matches your database field name for the question text
      correctAnswer: map['ftg_answer'], // Ensure this matches your database field name for the correct answer
    );
  }
}
