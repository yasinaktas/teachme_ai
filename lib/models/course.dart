import 'package:teachme_ai/models/instructor.dart';

class Course {
  final String id;
  final String title;
  final String description;
  final String language;
  final Instructor instructor;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.language,
    required this.instructor,
  });
}
