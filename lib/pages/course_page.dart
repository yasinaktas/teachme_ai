import 'package:flutter/material.dart';
import 'package:teachme_ai/models/course.dart';

class CoursePage extends StatelessWidget {
  final Course course;
  const CoursePage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text(course.title)),
    );
  }
}
