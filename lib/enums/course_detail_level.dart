enum CourseDetailLevel { minimal, basic, detailed, comprehensive }

extension CourseDetailLevelExtension on CourseDetailLevel {
  String get label {
    switch (this) {
      case CourseDetailLevel.minimal:
        return "Minimal";
      case CourseDetailLevel.basic:
        return "Basic";
      case CourseDetailLevel.detailed:
        return "Detailed";
      case CourseDetailLevel.comprehensive:
        return "Comprehensive";
    }
  }
}