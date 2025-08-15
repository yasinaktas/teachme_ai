import 'package:equatable/equatable.dart';
import 'package:teachme_ai/models/course.dart';

class CourseState extends Equatable {
  final List<Course> courses;
  final List<Course> filteredCourses;
  final bool isLoading;
  final String searchText;
  final String? error;

  const CourseState({
    required this.courses,
    this.filteredCourses = const [],
    this.isLoading = false,
    this.error,
    this.searchText = '',
  });

  CourseState copyWith({
    List<Course>? courses,
    List<Course>? filteredCourses,
    bool? isLoading,
    String? searchText,
    String? error,
  }) {
    return CourseState(
      courses: courses ?? this.courses,
      filteredCourses: filteredCourses ?? this.filteredCourses,
      isLoading: isLoading ?? this.isLoading,
      searchText: searchText ?? this.searchText,
      error: error,
    );
  }

  @override
  List<Object?> get props => [courses, isLoading, error, searchText,filteredCourses];
}
