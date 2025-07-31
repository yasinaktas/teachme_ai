import 'package:teachme_ai/models/chapter.dart';
import 'package:teachme_ai/models/course.dart';
import 'package:teachme_ai/services/i_course_service.dart';

class FakeCourseService implements ICourseService {
  @override
  Future<List<Course>> fetchCourses() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 3));

    // Return a list of fake courses
    return [
      Course(
        id: '1',
        title: 'Introduction to Flutter 1',
        description: 'Learn the basics of Flutter development.',
        language: "en",
        createdAt: DateTime.now(),
        chapters: [
          Chapter(
            id: '1',
            courseId: '1',
            title: 'Getting Started with Flutter',
            description: 'An introduction to Flutter and its features.',
            content:
                'Flutter is an open-source UI software development toolkit created by Google.',
            transcript:
                'This chapter covers the basics of Flutter development.',
            questions: [],
            isCompleted: true,
          ),
          Chapter(
            id: '2',
            courseId: '1',
            title: 'Building Your First App',
            description: 'Learn how to build your first Flutter application.',
            content: 'In this chapter, we will create a simple Flutter app.',
            transcript:
                'This chapter guides you through building your first app.',
            questions: [],
          ),
          Chapter(
            id: '3',
            courseId: '1',
            title: 'State Management in Flutter',
            description:
                'Understanding state management in Flutter applications.',
            content:
                'State management is crucial for building responsive apps.',
            transcript:
                'This chapter explains different state management techniques.',
            questions: [],
          ),
          Chapter(
            id: '4',
            courseId: '1',
            title: 'Networking in Flutter',
            description: 'Learn how to make network requests in Flutter.',
            content:
                'Flutter provides various ways to handle network requests.',
            transcript:
                'This chapter covers networking in Flutter applications.',
            questions: [],
          ),
        ],
      ),
      Course(
        id: '2',
        title: 'Introduction to Flutter 2',
        description: 'Learn the basics of Flutter development.',
        language: "en",

        createdAt: DateTime.now(),
        chapters: [
          Chapter(
            id: '1',
            courseId: '2',
            title: 'Getting Started with Flutter',
            description: 'An introduction to Flutter and its features.',
            content:
                'Flutter is an open-source UI software development toolkit created by Google.',
            transcript:
                'This chapter covers the basics of Flutter development.',
            questions: [],
            isCompleted: true,
          ),
          Chapter(
            id: '2',
            courseId: '2',
            title: 'Building Your First App',
            description: 'Learn how to build your first Flutter application.',
            content: 'In this chapter, we will create a simple Flutter app.',
            transcript:
                'This chapter guides you through building your first app.',
            questions: [],
            isCompleted: true,
          ),
          Chapter(
            id: '3',
            courseId: '2',
            title: 'State Management in Flutter',
            description:
                'Understanding state management in Flutter applications.',
            content:
                'State management is crucial for building responsive apps.',
            transcript:
                'This chapter explains different state management techniques.',
            questions: [],
            isCompleted: true,
          ),
          Chapter(
            id: '4',
            courseId: '2',
            title: 'Networking in Flutter',
            description: 'Learn how to make network requests in Flutter.',
            content:
                'Flutter provides various ways to handle network requests.',
            transcript:
                'This chapter covers networking in Flutter applications.',
            questions: [],
            isCompleted: true,
          ),
          Chapter(
            id: '5',
            courseId: '2',
            title: 'Networking in Flutter',
            description: 'Learn how to make network requests in Flutter.',
            content:
                'Flutter provides various ways to handle network requests.',
            transcript:
                'This chapter covers networking in Flutter applications.',
            questions: [],
          ),
        ],
      ),
      Course(
        id: '2',
        title: 'Introduction to Flutter 2',
        description: 'Learn the basics of Flutter development.',
        language: "en",

        createdAt: DateTime.now(),
        chapters: [
          Chapter(
            id: '1',
            courseId: '2',
            title: 'Getting Started with Flutter',
            description: 'An introduction to Flutter and its features.',
            content:
                'Flutter is an open-source UI software development toolkit created by Google.',
            transcript:
                'This chapter covers the basics of Flutter development.',
            questions: [],
            isCompleted: false,
          ),
          Chapter(
            id: '2',
            courseId: '2',
            title: 'Building Your First App',
            description: 'Learn how to build your first Flutter application.',
            content: 'In this chapter, we will create a simple Flutter app.',
            transcript:
                'This chapter guides you through building your first app.',
            questions: [],
            isCompleted: false,
          ),
          Chapter(
            id: '3',
            courseId: '2',
            title: 'State Management in Flutter',
            description:
                'Understanding state management in Flutter applications.',
            content:
                'State management is crucial for building responsive apps.',
            transcript:
                'This chapter explains different state management techniques.',
            questions: [],
            isCompleted: false,
          ),
          Chapter(
            id: '4',
            courseId: '2',
            title: 'Networking in Flutter',
            description: 'Learn how to make network requests in Flutter.',
            content:
                'Flutter provides various ways to handle network requests.',
            transcript:
                'This chapter covers networking in Flutter applications.',
            questions: [],
            isCompleted: false,
          ),
          Chapter(
            id: '5',
            courseId: '2',
            title: 'Networking in Flutter',
            description: 'Learn how to make network requests in Flutter.',
            content:
                'Flutter provides various ways to handle network requests.',
            transcript:
                'This chapter covers networking in Flutter applications.',
            questions: [],
          ),
        ],
      ),
      Course(
        id: '2',
        title: 'Introduction to Flutter 2',
        description: 'Learn the basics of Flutter development.',
        language: "en",

        createdAt: DateTime.now(),
        chapters: [
          Chapter(
            id: '1',
            courseId: '2',
            title: 'Getting Started with Flutter',
            description: 'An introduction to Flutter and its features.',
            content:
                'Flutter is an open-source UI software development toolkit created by Google.',
            transcript:
                'This chapter covers the basics of Flutter development.',
            questions: [],
            isCompleted: true,
          ),
          Chapter(
            id: '2',
            courseId: '2',
            title: 'Building Your First App',
            description: 'Learn how to build your first Flutter application.',
            content: 'In this chapter, we will create a simple Flutter app.',
            transcript:
                'This chapter guides you through building your first app.',
            questions: [],
            isCompleted: true,
          ),
          Chapter(
            id: '3',
            courseId: '2',
            title: 'State Management in Flutter',
            description:
                'Understanding state management in Flutter applications.',
            content:
                'State management is crucial for building responsive apps.',
            transcript:
                'This chapter explains different state management techniques.',
            questions: [],
            isCompleted: true,
          ),
          Chapter(
            id: '4',
            courseId: '2',
            title: 'Networking in Flutter',
            description: 'Learn how to make network requests in Flutter.',
            content:
                'Flutter provides various ways to handle network requests.',
            transcript:
                'This chapter covers networking in Flutter applications.',
            questions: [],
            isCompleted: true,
          ),
          Chapter(
            id: '5',
            courseId: '2',
            title: 'Networking in Flutter',
            description: 'Learn how to make network requests in Flutter.',
            content:
                'Flutter provides various ways to handle network requests.',
            transcript:
                'This chapter covers networking in Flutter applications.',
            questions: [],
          ),
        ],
      ),
      Course(
        id: '2',
        title: 'Introduction to Flutter 2',
        description: 'Learn the basics of Flutter development.',
        language: "en",

        createdAt: DateTime.now(),
        chapters: [
          Chapter(
            id: '1',
            courseId: '2',
            title: 'Getting Started with Flutter',
            description: 'An introduction to Flutter and its features.',
            content:
                'Flutter is an open-source UI software development toolkit created by Google.',
            transcript:
                'This chapter covers the basics of Flutter development.',
            questions: [],
            isCompleted: true,
          ),
          Chapter(
            id: '2',
            courseId: '2',
            title: 'Building Your First App',
            description: 'Learn how to build your first Flutter application.',
            content: 'In this chapter, we will create a simple Flutter app.',
            transcript:
                'This chapter guides you through building your first app.',
            questions: [],
            isCompleted: true,
          ),
          Chapter(
            id: '3',
            courseId: '2',
            title: 'State Management in Flutter',
            description:
                'Understanding state management in Flutter applications.',
            content:
                'State management is crucial for building responsive apps.',
            transcript:
                'This chapter explains different state management techniques.',
            questions: [],
            isCompleted: true,
          ),
          Chapter(
            id: '4',
            courseId: '2',
            title: 'Networking in Flutter',
            description: 'Learn how to make network requests in Flutter.',
            content:
                'Flutter provides various ways to handle network requests.',
            transcript:
                'This chapter covers networking in Flutter applications.',
            questions: [],
            isCompleted: true,
          ),
          Chapter(
            id: '5',
            courseId: '2',
            title: 'Networking in Flutter',
            description: 'Learn how to make network requests in Flutter.',
            content:
                'Flutter provides various ways to handle network requests.',
            transcript:
                'This chapter covers networking in Flutter applications.',
            questions: [],
          ),
        ],
      ),
    ];
  }
}
