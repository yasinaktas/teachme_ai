import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/course/course_event.dart';
import 'package:teachme_ai/blocs/course/course_state.dart';
import 'package:teachme_ai/repositories/i_course_repository.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final ICourseRepository courseRepository;

  CourseBloc({required this.courseRepository})
    : super(CourseState(courses: [], isLoading: false)) {
    on<CourseFetchEvent>(_onFetchCourses);
    on<CourseAddEvent>(_onAddCourse);
    //add(CourseFetchEvent()); // Dikkatli kullanılması gerekiyormuş çünkü BuildContext hazır olmayabilirmiş!
  }

  FutureOr<void> _onFetchCourses(
    CourseFetchEvent event,
    Emitter<CourseState> emit,
  ) async{
    emit(state.copyWith(isLoading: true));
    try {
      final courses = await courseRepository.getCourses();
      emit(state.copyWith(courses: courses, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  FutureOr<void> _onAddCourse(
    CourseAddEvent event,
    Emitter<CourseState> emit,
  ) {}
}
