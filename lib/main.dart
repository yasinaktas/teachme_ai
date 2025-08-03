import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/auth/auth_bloc.dart';
import 'package:teachme_ai/blocs/auth/auth_event.dart';
import 'package:teachme_ai/blocs/chapter/chapter_bloc.dart';
import 'package:teachme_ai/blocs/course/course_bloc.dart';
import 'package:teachme_ai/blocs/course/course_event.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_bloc.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/firebase_options.dart';
import 'package:teachme_ai/models/chapter.dart';
import 'package:teachme_ai/models/course.dart';
import 'package:teachme_ai/pages/add_course_page.dart';
import 'package:teachme_ai/pages/auth_page.dart';
import 'package:teachme_ai/pages/chapter_page.dart';
import 'package:teachme_ai/pages/course_page.dart';
import 'package:teachme_ai/pages/host_page.dart';
import 'package:teachme_ai/pages/login_page.dart';
import 'package:teachme_ai/pages/profile_page.dart';
import 'package:teachme_ai/pages/signup_page.dart';
import 'package:teachme_ai/pages/splash_page.dart';
import 'package:teachme_ai/pages/subscription_page.dart';
import 'package:teachme_ai/repositories/fake_course_repository.dart';
import 'package:teachme_ai/repositories/generate_course_repository.dart';
import 'package:teachme_ai/repositories/google_tts_repository.dart';
import 'package:teachme_ai/services/fake_course_service.dart';
import 'package:teachme_ai/services/gemini_api_service.dart';
import 'package:teachme_ai/services/google_tts_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    FakeCourseRepository fakeCourseRepository = FakeCourseRepository(
      courseService: FakeCourseService(),
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider<CourseBloc>(
          create: (context) =>
              CourseBloc(courseRepository: fakeCourseRepository)
                ..add(CourseFetchEvent()),
        ),
        BlocProvider<AuthBloc>(
          create: (context) =>
              AuthBloc(FirebaseAuth.instance)..add(AppStarted()),
        ),
        BlocProvider<GenerateCourseBloc>(
          create: (context) => GenerateCourseBloc(
            generateCourseRepository: GenerateCourseRepository(
              aiApiService: GeminiApiService(),
            ),
            ttsRepository: GoogleTtsRepository(GoogleTtsService()),
          ),
        ),
        BlocProvider<ChapterBloc>(
          create: (context) =>
              ChapterBloc(courseRepository: fakeCourseRepository),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.backgroundColor,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.backgroundColor,
            systemOverlayStyle: SystemUiOverlayStyle(
              systemNavigationBarColor: AppColors.backgroundColor,
              systemNavigationBarIconBrightness: Brightness.dark,
              statusBarColor: AppColors.backgroundColor,
              statusBarIconBrightness: Brightness.dark,
            ),
          ),
        ),
        initialRoute: "/",
        routes: {
          "/": (context) => const SplashPage(),
          "/host": (context) => const HostPage(),
          "/auth": (context) => const AuthPage(),
          "/login": (context) => const LoginPage(),
          "/signup": (context) => const SignupPage(),
          "/addCourse": (context) => const AddCoursePage(),
          "/profile": (context) => const ProfilePage(),
          "/course": (context) {
            final course = ModalRoute.of(context)?.settings.arguments;
            return CoursePage(course: course as Course);
          },
          "/chapter": (context) {
            final chapter = ModalRoute.of(context)?.settings.arguments;
            return ChapterPage(chapter: chapter as Chapter);
          },
          "/subscription": (context) => const SubscriptionPage(),
        },
      ),
    );
  }
}
