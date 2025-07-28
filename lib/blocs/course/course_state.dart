import 'package:teachme_ai/models/course.dart';

class CourseState {
  final List<Course> courses;
  final bool isLoading;
  final String? error; 

  CourseState({
    required this.courses,
    this.isLoading = false,
    this.error,
  });

  CourseState copyWith({
    List<Course>? courses,
    bool? isLoading,
    String? error,
  }) {
    return CourseState(
      courses: courses ?? this.courses,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}