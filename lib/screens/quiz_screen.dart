import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordwizz/models/quiz_model.dart';
import 'package:wordwizz/components/database_helper.dart';
import 'package:wordwizz/models/question_model.dart';
import '../providers/font_size_provider.dart';

class QuizScreen extends StatefulWidget {
  final Quiz quiz;

  QuizScreen({Key? key, required this.quiz}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Future<bool> futureDatabaseExists;
  late Future<List<Question>> futureQuestions;
  Map<int, int?> selectedAnswers = {};
  int currentQuestionIndex = 0;
  int score = 0;
  List<Question> loadedQuestions = [];

  @override
  void initState() {
    super.initState();
    score = 0;
    futureDatabaseExists = DatabaseHelper().checkDatabaseExists();
    futureQuestions = getQuestionsForQuiz();
  }

  Future<List<Question>> getQuestionsForQuiz() async {
    try {
      final db = await DatabaseHelper().database;
      String language = widget.quiz.language.toString();
      String level = widget.quiz.level.toString();

      final result = await db.rawQuery(
        'SELECT * FROM TEST_QUESTIONS WHERE question_language = ? AND question_level = ? ORDER BY RANDOM() LIMIT 10',
        [language, level],
      );

      List<Question> questions = [];
      for (var questionMap in result) {
        final answerMaps = await db.rawQuery(
          'SELECT * FROM TEST_ANSWERS WHERE question_id = ?',
          [questionMap['question_id']],
        );

        List<Answer> answers = answerMaps.map((map) => Answer.fromMap(map)).toList();
        Question question = Question.fromMap(questionMap, answers);
        questions.add(question);
      }

      loadedQuestions = questions;
      return questions;
    } catch (e) {
      throw Exception('Error reading from database: $e');
    }
  }

  void selectAnswer(int questionId, int answerId) {
    setState(() {
      selectedAnswers[questionId] = answerId;
    });
  }

  bool isAnswerCorrect(int questionId, int selectedAnswerId) {
    final question = loadedQuestions.firstWhere((q) => q.id == questionId);
    final answer = question.answers.firstWhere((a) => a.id == selectedAnswerId);
    return answer.isCorrect;
  }

  void nextQuestion() {
    setState(() {
      if (selectedAnswers.containsKey(loadedQuestions[currentQuestionIndex].id)) {
        int questionId = loadedQuestions[currentQuestionIndex].id;
        int? selectedAnswerId = selectedAnswers[questionId];

        if (selectedAnswerId != null && isAnswerCorrect(questionId, selectedAnswerId)) {
          score++;
        }
      }

      if (currentQuestionIndex < 9) {
        currentQuestionIndex++;
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => EndScreen(score: score),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.quiz.title,
          style: TextStyle(fontSize: fontSizeProvider.fontSize),
        ),
      ),
      body: FutureBuilder<bool>(
        future: futureDatabaseExists,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error checking database: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data == false) {
            return Center(child: Text('Database file not found in assets.'));
          } else {
            return FutureBuilder<List<Question>>(
              future: futureQuestions,
              builder: (context, questionSnapshot) {
                if (questionSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (questionSnapshot.hasError) {
                  return Center(child: Text('Error reading database: ${questionSnapshot.error}'));
                } else if (questionSnapshot.hasData && questionSnapshot.data!.isNotEmpty) {
                  final questions = questionSnapshot.data!;
                  final question = questions[currentQuestionIndex];
                  return Card(
                    margin: EdgeInsets.all(10.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Question ${currentQuestionIndex + 1} of 10',
                            style: TextStyle(
                              fontSize: fontSizeProvider.fontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            question.questionText,
                            style: TextStyle(
                              fontSize: fontSizeProvider.fontSize + 2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          ...question.answers.map((answer) {
                            bool isSelected = selectedAnswers[question.id] == answer.id;
                            bool isCorrect = answer.isCorrect;

                            Color? answerColor = isSelected
                                ? (isCorrect ? Colors.green : Colors.red)
                                : null;

                            return ListTile(
                              title: Text(
                                answer.answerText,
                                style: TextStyle(
                                  color: answerColor,
                                  fontSize: fontSizeProvider.fontSize,
                                ),
                              ),
                              leading: Icon(
                                isSelected
                                    ? (isCorrect ? Icons.check_circle : Icons.cancel)
                                    : Icons.radio_button_unchecked,
                                color: isSelected ? (isCorrect ? Colors.green : Colors.red) : null,
                              ),
                              onTap: () => selectAnswer(question.id, answer.id),
                            );
                          }).toList(),
                          SizedBox(height: 10),
                          if (selectedAnswers.containsKey(question.id))
                            ElevatedButton(
                              onPressed: () => nextQuestion(),
                              child: Text(
                                'Next Question',
                                style: TextStyle(fontSize: fontSizeProvider.fontSize),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Center(child: Text('No questions available for this quiz.'));
                }
              },
            );
          }
        },
      ),
    );
  }
}

class EndScreen extends StatelessWidget {
  final int score;

  EndScreen({required this.score});

  @override
  Widget build(BuildContext context) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quiz Completed',
          style: TextStyle(fontSize: fontSizeProvider.fontSize),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Score',
              style: TextStyle(
                fontSize: fontSizeProvider.fontSize + 6,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              '$score / 10',
              style: TextStyle(
                fontSize: fontSizeProvider.fontSize + 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Back to Quiz Levels',
                style: TextStyle(fontSize: fontSizeProvider.fontSize),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
