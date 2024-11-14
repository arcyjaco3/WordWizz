import 'package:flutter/material.dart';
import 'package:wordwizz/models/links_model.dart';
import 'package:provider/provider.dart';
import 'package:wordwizz/providers/font_size_provider.dart';


// File: course_list_screen.dart
class CourseListScreen extends StatelessWidget {
  CourseListScreen({super.key});

  final List<Course> courses = [
    Course(
      title: 'English for Beginners (A1)',
      description: 'Basic English course covering common phrases and grammar.',
      grammar: 'Introduction to basic tenses, simple vocabulary.',
      youtubeLink: 'https://www.youtube.com/watch?v=exampleA1',
    ),
    Course(
      title: 'Intermediate English (B1)',
      description: 'Builds on foundational language skills and conversation.',
      grammar: 'Past, present, and future tenses, complex sentences.',
      youtubeLink: 'https://www.youtube.com/watch?v=exampleB1',
    ),
    Course(
      title: 'Advanced English (C1)',
      description: 'Advanced grammar and fluency for academic or professional use.',
      grammar: 'Advanced grammatical structures, idioms.',
      youtubeLink: 'https://www.youtube.com/watch?v=exampleC1',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 10.0), // Przesunięcie tytułu dla lepszej kompatybilności z wycięciami

        ),
        elevation: 1,
      ),
      body: SafeArea( // Zabezpieczenie przed wycięciami ekranu
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  title: Text(
                    courses[index].title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Text(
                      courses[index].description,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseDetailScreen(course: courses[index]),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// File: course_detail_screen.dart
class CourseDetailScreen extends StatelessWidget {
  final Course course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final fontSize = Provider.of<FontSizeProvider>(context).fontSize;

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 10.0), // Przesunięcie tytułu dla lepszej kompatybilności z wycięciami
          child: Text(course.title, style: TextStyle(fontSize: fontSize)),
        ),
        elevation: 1,
      ),
      body: SafeArea( // Zabezpieczenie przed wycięciami ekranu
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Course Description:',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  course.description,
                  style: TextStyle(
                    fontSize: fontSize,
                  ),
                ),
                const Divider(height: 32, color: Colors.black26),
                Text(
                  'Grammar:',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  course.grammar,
                  style: TextStyle(
                    fontSize: fontSize,
                  ),
                ),
                const Divider(height: 32, color: Colors.black26),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: () {
                      // Placeholder for functionality
                    },
                    child: Text('Go to YouTube Course', style: TextStyle(fontSize: fontSize, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
