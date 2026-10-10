import 'package:flutter/material.dart';
<<<<<<< HEAD:lib/shared/widgets/alert_loading.dart
import 'package:learn_app/core/constants/app_color.dart';
import 'package:learn_app/shared/widgets/my_text_style.dart';
=======
import 'package:learn_app/constants/app_color.dart';
import 'package:learn_app/widgets/my_text_style.dart';
>>>>>>> upstream/main:lib/widgets/alert_loading.dart

void alertLoading(BuildContext context, {String? message}) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: AppColors.whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppColors.primaryColor),
            SizedBox(height: 10),
            Text(
              message ?? 'ກະລຸນາລໍຖ້າ...',
              style: myTextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    },
  );
}
