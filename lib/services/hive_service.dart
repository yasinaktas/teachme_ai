import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:teachme_ai/models/answer.dart';
import 'package:teachme_ai/models/chapter.dart';
import 'package:teachme_ai/models/course.dart';
import 'package:teachme_ai/models/question.dart';

class HiveService {
  static Future<void> init() async {
    final appDir = await getApplicationDocumentsDirectory();
    Hive.init(appDir.path);

    Hive.registerAdapter(CourseAdapter());
    Hive.registerAdapter(ChapterAdapter());
    Hive.registerAdapter(QuestionAdapter());
    Hive.registerAdapter(AnswerAdapter());

    await Hive.openBox<Course>('courses');
    await Hive.openBox<dynamic>('settings');
  }
}
