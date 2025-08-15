import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/course/course_bloc.dart';
import 'package:teachme_ai/blocs/course/course_event.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/widgets/app_alert_dialog.dart';
import 'package:teachme_ai/widgets/app_snack_bar.dart';

class DeleteCoursePopup extends StatelessWidget {
  final String courseId;
  const DeleteCoursePopup({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: AppColors.backgroundColor,
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: 'delete',
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text('Delete Course'),
            ),
          ),
        ];
      },
      icon: Icon(Icons.more_vert),
      onSelected: (value) {
        if (value == 'delete') {
          showDialog(
            context: context,
            builder: (context) {
              return AppAlertDialog(
                title: "Delete Course",
                content: "Are you sure you want to delete this course?",
                actionButtonText: "Delete",
                onActionButtonPressed: () {
                  BlocProvider.of<CourseBloc>(
                    context,
                  ).add(CourseDeleteEvent(courseId));
                  Navigator.of(context).pop();
                  AppSnackBar.show(
                    context,
                    message: "Course deleted successfully",
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}
