import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordwizz/models/quiz_model.dart';
import 'package:wordwizz/components/database_helper.dart';
import 'package:wordwizz/models/question_model.dart';
import 'package:wordwizz/models/fill_the_gap_question.dart';
import '../providers/font_size_provider.dart';

class QuizScreen extends StatefulWidget {
  final Quiz quiz;

  QuizScreen({Key? key, required this.quiz}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Future<bool> futureDatabaseExists;
  late Future<List<dynamic>> futureQuestions;
  Map<int, dynamic> selectedAnswers = {};
  int currentQuestionIndex = 0;
  int score = 0;
  List<dynamic> loadedQuestions = [];
  bool? isCorrectAnswer;
  bool showNextButton = false;
  bool isAnswerSubmitted = false;
  final TextEditingController answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    score = 0;
    futureDatabaseExists = DatabaseHelper().checkDatabaseExists();
    futureQuestions = getQuestionsForQuiz();
  }

  Future<List<dynamic>> getQuestionsForQuiz() async {
    try {
      final db = await DatabaseHelper().database;
      String language = widget.quiz.language.toString();
      String level = widget.quiz.level.toString();

      final multipleChoiceResult = await db.rawQuery(
        'SELECT * FROM TEST_QUESTIONS WHERE question_language = ? AND question_level = ? ORDER BY RANDOM() LIMIT 5',
        [language, level],
      );

      final fillGapResult = await db.rawQuery(
        'SELECT * FROM FILL_THE_GAP WHERE ftg_language = ? AND ftg_level = ? ORDER BY RANDOM() LIMIT 5',
        [language, level],
      );

      List<dynamic> questions = [];

      for (var questionMap in multipleChoiceResult) {
        final answerMaps = await db.rawQuery(
          'SELECT * FROM TEST_ANSWERS WHERE question_id = ?',
          [questionMap['question_id']],
        );
        List<Answer> answers = answerMaps.map((map) => Answer.fromMap(map)).toList();
        questions.add(Question.fromMap(questionMap, answers));
      }

      for (var gapMap in fillGapResult) {
        questions.add(FillTheGapQuestion.fromMap(gapMap));
      }

      loadedQuestions = questions;
      return questions;
    } catch (e) {
      throw Exception('Error reading from database: $e');
    }
  }

  void selectAnswer(int questionId, dynamic answer) {
    setState(() {
      if (!selectedAnswers.containsKey(questionId)) {
        selectedAnswers[questionId] = answer;
      }
    });
  }

  bool isAnswerCorrect(int questionId, int selectedAnswerId) {
    final question = loadedQuestions.firstWhere((q) => q.id == questionId);
    final answer = question.answers.firstWhere((a) => a.id == selectedAnswerId);
    return answer.isCorrect;
  }

  void checkFillGapAnswer(FillTheGapQuestion question) {
    String? userAnswer = selectedAnswers[question.id];
    if (userAnswer == null || userAnswer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter an answer before submitting.')),
      );
      return;
    }

    setState(() {
      if (userAnswer.toLowerCase().trim() == question.correctAnswer.toLowerCase().trim()) {
        if (isCorrectAnswer == null) {
          score++;
        }
        isCorrectAnswer = true;
      } else {
        isCorrectAnswer = false;
      }
      showNextButton = true;
      isAnswerSubmitted = true;
    });
  }

  void nextQuestion() {
    setState(() {
      final currentQuestion = loadedQuestions[currentQuestionIndex];
      if (currentQuestion is Question) {
        int? selectedAnswerId = selectedAnswers[currentQuestion.id];
        if (selectedAnswerId != null && isAnswerCorrect(currentQuestion.id, selectedAnswerId)) {
          score++;
        }
      }

      showNextButton = false;
      isCorrectAnswer = null;
      isAnswerSubmitted = false;
      answerController.clear();

      if (currentQuestionIndex < loadedQuestions.length - 1) {
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
            return FutureBuilder<List<dynamic>>(
              future: futureQuestions,
              builder: (context, questionSnapshot) {
                if (questionSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (questionSnapshot.hasError) {
                  return Center(child: Text('Error reading database: ${questionSnapshot.error}'));
                } else if (questionSnapshot.hasData && questionSnapshot.data!.isNotEmpty) {
                  final question = questionSnapshot.data![currentQuestionIndex];
                  
                  if (question is Question) {
                    return buildMultipleChoiceQuestion(question, fontSizeProvider);
                  } else if (question is FillTheGapQuestion) {
                    return buildFillTheGapQuestion(question, fontSizeProvider);
                  }
                } else {
                  return Center(child: Text('No questions available for this quiz.'));
                }
                return Container();
              },
            );
          }
        },
      ),
    );
  }

  Widget buildMultipleChoiceQuestion(Question question, FontSizeProvider fontSizeProvider) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${currentQuestionIndex + 1} of ${loadedQuestions.length}',
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
  }

  Widget buildFillTheGapQuestion(FillTheGapQuestion question, FontSizeProvider fontSizeProvider) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${currentQuestionIndex + 1} of ${loadedQuestions.length}',
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
            TextField(
              controller: answerController,
              onChanged: (value) => selectedAnswers[question.id] = value,
              decoration: InputDecoration(labelText: 'Enter the missing word'),
              enabled: !isAnswerSubmitted,
            ),
            if (isCorrectAnswer != null) 
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  isCorrectAnswer! ? 'Correct!' : 'Incorrect.',
                  style: TextStyle(
                    color: isCorrectAnswer! ? Colors.green : Colors.red,
                    fontSize: fontSizeProvider.fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: showNextButton
                  ? () => nextQuestion()
                  : () => checkFillGapAnswer(question),
              child: Text(
                showNextButton ? 'Next Question' : 'Submit Answer',
                style: TextStyle(fontSize: fontSizeProvider.fontSize),
              ),
            ),
          ],
        ),
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
