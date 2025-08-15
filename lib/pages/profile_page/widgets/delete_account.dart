import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/auth/auth_bloc.dart';
import 'package:teachme_ai/blocs/auth/auth_event.dart';
import 'package:teachme_ai/blocs/cache/cache_bloc.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/constants/app_styles.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:teachme_ai/widgets/app_alert_dialog.dart';
import 'package:teachme_ai/widgets/app_elevated_button.dart';

class DeleteAccount extends StatelessWidget {
  const DeleteAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            "Delete your account and all associated data. This action is irreversible.",
            style: AppStyles.textStyleSmallLight,
          ),
        ),
        const SizedBox(width: AppDimensions.pagePadding),
        AppElevatedButton(
          isActive: true,
          backgroundColor: Colors.red,
          text: "Delete",
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AppAlertDialog(
                title: "Delete Account",
                content:
                    "Are you sure you want to delete your account? This action cannot be undone.",
                actionButtonText: "Delete",
                onActionButtonPressed: () {
                  final userId = context.read<CacheBloc>().state.userId;
                  context.read<AuthBloc>().add(DeleteAccountRequested(userId));
                },
              ),
            );
          },
        ),
      ],
    ).withPadding(
      const EdgeInsets.symmetric(horizontal: AppDimensions.pagePadding),
    );
  }
}
