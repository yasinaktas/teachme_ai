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
    on<ChapterUpdateEvent>(_onChapterUpdate);
    on<CourseUpdateEvent>(_onUpdateCourse);
    on<CourseSearchEvent>(_onSearchCourses);
    on<CourseDeleteEvent>(_onDeleteCourse);
  }

  Future<void> _onFetchCourses(
    CourseFetchEvent event,
    Emitter<CourseState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final courses = await courseRepository.getCourses();
      emit(
        state.copyWith(
          courses: courses,
          isLoading: false,
          filteredCourses: courses,
          searchText: '',
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onAddCourse(
    CourseAddEvent event,
    Emitter<CourseState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      await courseRepository.addCourse(event.course);
      add(CourseFetchEvent());
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onChapterUpdate(
    ChapterUpdateEvent event,
    Emitter<CourseState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final updatedCourse = state.courses.firstWhere(
        (course) => course.id == event.chapter.courseId,
      );
      final updatedChapters = updatedCourse.chapters.map((chapter) {
        return chapter.id == event.chapter.id ? event.chapter : chapter;
      }).toList();
      final updatedCourseWithChapters = updatedCourse.copyWith(
        chapters: updatedChapters,
      );
      add(CourseUpdateEvent(updatedCourseWithChapters));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onUpdateCourse(
    CourseUpdateEvent event,
    Emitter<CourseState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      await courseRepository.updateCourse(event.course);
      add(CourseFetchEvent());
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onSearchCourses(
    CourseSearchEvent event,
    Emitter<CourseState> emit,
  ) async {
    if (event.searchText.isEmpty) {
      emit(state.copyWith(filteredCourses: state.courses, isLoading: false));
      return;
    }
    emit(state.copyWith(searchText: event.searchText, isLoading: true));
    try {
      final courses = state.courses.where((course) {
        return course.title.toLowerCase().contains(
              event.searchText.toLowerCase(),
            ) ||
            course.description.toLowerCase().contains(
              event.searchText.toLowerCase(),
            );
      }).toList();
      emit(state.copyWith(filteredCourses: courses, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onDeleteCourse(CourseDeleteEvent event, Emitter<CourseState> emit) async{
    emit(state.copyWith(isLoading: true));
    try {
      await courseRepository.deleteCourse(event.courseId);
      add(CourseFetchEvent());
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
