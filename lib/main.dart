import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/course/course_bloc.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/pages/add_course_page.dart';
import 'package:teachme_ai/pages/host_page.dart';
import 'package:teachme_ai/pages/profile_page.dart';
import 'package:teachme_ai/repositories/fake_course_repository.dart';
import 'package:teachme_ai/services/fake_course_service.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CourseBloc>(
          create: (context) => CourseBloc(
            courseRepository: FakeCourseRepository(
              courseService: FakeCourseService(),
            ),
          ),
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
          "/": (context) => const HostPage(),
          "/addCourse": (context) => const AddCoursePage(),
          "/profile": (context) => const ProfilePage(),
        },
      ),
    );
  }
}
