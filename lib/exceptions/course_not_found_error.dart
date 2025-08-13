class CourseNotFoundErrorException implements Exception {
  final String message;

  CourseNotFoundErrorException({this.message = "Course or Chapter not found."});
}