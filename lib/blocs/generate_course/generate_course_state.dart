import 'package:teachme_ai/dto/dto_subtopics.dart';

abstract class GenerateCourseState {}

class GenerateSubtopicsLoading extends GenerateCourseState {}

class SubtopicsLoaded extends GenerateCourseState {
  final DtoSubtopics subtopics;

  SubtopicsLoaded(this.subtopics);
}

