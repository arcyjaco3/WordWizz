import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordwizz/models/links_model.dart';
import '../providers/font_size_provider.dart';

class CourseDetailScreen extends StatelessWidget {
  final Course course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final fontSize = Provider.of<FontSizeProvider>(context).fontSize;

    return Scaffold(
      appBar: AppBar(
        title: Text(course.title, style: TextStyle(fontSize: fontSize)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Opis kursu:',
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(course.description, style: TextStyle(fontSize: fontSize)),
            const SizedBox(height: 16),
            Text(
              'Gramatyka:',
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(course.grammar, style: TextStyle(fontSize: fontSize)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: Text('Przejdź do kursu na YouTube', style: TextStyle(fontSize: fontSize)),
            ),
          ],
        ),
      ),
    );
  }
}
