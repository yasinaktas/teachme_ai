abstract class GenerateCourseEvent {}

class GenerateSubtopics extends GenerateCourseEvent {
  final String topic;
  GenerateSubtopics(this.topic);
}