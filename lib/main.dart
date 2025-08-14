import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:teachme_ai/blocs/settings/settings_bloc.dart';
import 'package:teachme_ai/blocs/settings/settings_event.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/firebase_options.dart';
import 'package:teachme_ai/models/chapter.dart';
import 'package:teachme_ai/pages/generate_course_page/add_course_page.dart';
import 'package:teachme_ai/pages/auth_page/auth_page.dart';
import 'package:teachme_ai/pages/chapter_page/chapter_page.dart';
import 'package:teachme_ai/pages/course_page/course_page.dart';
import 'package:teachme_ai/pages/host_page/host_page.dart';
import 'package:teachme_ai/pages/profile_page/profile_page.dart';
import 'package:teachme_ai/pages/splash_page/splash_page.dart';
import 'package:teachme_ai/pages/subscription_page/subscription_page.dart';
import 'package:teachme_ai/repositories/auth_repository.dart';
import 'package:teachme_ai/repositories/generate_course_repository.dart';
import 'package:teachme_ai/repositories/google_tts_repository.dart';
import 'package:teachme_ai/repositories/hive_course_repository.dart';
import 'package:teachme_ai/repositories/hive_settings_repository.dart';
import 'package:teachme_ai/services/gemini_api_service.dart';
import 'package:teachme_ai/services/google_tts_service.dart';
import 'package:teachme_ai/services/hive_course_service.dart';
import 'package:teachme_ai/services/hive_service.dart';
import 'package:teachme_ai/services/hive_settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await HiveService.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    HiveCourseRepository courseRepository = HiveCourseRepository(
      HiveCourseService(),
    );
    HiveSettingsRepository settingsRepository = HiveSettingsRepository(
      HiveSettingsService(),
    );
    GoogleTtsRepository ttsRepository = GoogleTtsRepository(GoogleTtsService());
    AuthRepository authRepository = AuthRepository();
    return MultiBlocProvider(
      providers: [
        BlocProvider<CourseBloc>(
          create: (context) =>
              CourseBloc(courseRepository: courseRepository)
                ..add(CourseFetchEvent()),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            FirebaseAuth.instance,
            FirebaseFirestore.instance,
            settingsRepository,
            authRepository,
          )..add(AppStarted()),
        ),
        BlocProvider<GenerateCourseBloc>(
          create: (context) => GenerateCourseBloc(
            generateCourseRepository: GenerateCourseRepository(
              aiApiService: GeminiApiService(),
            ),
            ttsRepository: ttsRepository,
            settingsRepository: settingsRepository,
          ),
        ),
        BlocProvider<ChapterBloc>(
          create: (context) => ChapterBloc(
            courseRepository: courseRepository,
            ttsRepository: ttsRepository,
          ),
        ),
        BlocProvider<SettingsBloc>(
          create: (context) =>
              SettingsBloc(HiveSettingsRepository(HiveSettingsService()))
                ..add(SettingsInitialEvent()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.backgroundColor,
          appBarTheme: AppBarTheme(
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
          "/addCourse": (context) => const AddCoursePage(),
          "/profile": (context) => const ProfilePage(),
          "/course": (context) {
            final courseId = ModalRoute.of(context)?.settings.arguments;
            return CoursePage(courseId: courseId as String);
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
