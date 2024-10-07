class Question {
  final int id;
  final String questionText;
  final List<Answer> answers;

  Question({
    required this.id,
    required this.questionText,
    required this.answers,
  });

  factory Question.fromMap(Map<String, dynamic> map, List<Answer> answers) {
    return Question(
      id: map['question_id'],
      questionText: map['question_text'],
      answers: answers,
    );
  }
}

class Answer {
  final int id;
  final String answerText;
  final bool isCorrect;

  Answer({
    required this.id,
    required this.answerText,
    required this.isCorrect,
  });

  factory Answer.fromMap(Map<String, dynamic> map) {
    return Answer(
      id: map['answer_id'],
      answerText: map['answer_text'],
      isCorrect: map['is_correct'] == 1,
    );
  }
}
