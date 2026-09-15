import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';

// رابط نصي قابل للضغط بألوان وتنسيق تحددهما الشاشة.
class AuthLinkText extends StatelessWidget {

  final String text;

  final String actionText;

  final VoidCallback onTap;

  const AuthLinkText({
    super.key,
    required this.text,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(

      mainAxisSize: MainAxisSize.min,

      textDirection: TextDirection.rtl,

      children: [
        Text(
          text,
          style: AppTextStyles.secondaryText,
        ),
        GestureDetector(

          onTap: onTap,

          child: Text(
            actionText,
            style: AppTextStyles.actionText,
          ),
        ),
      ],
    );
  }
}
