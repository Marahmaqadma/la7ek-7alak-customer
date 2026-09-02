import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';

class AuthLinkText extends StatelessWidget {
  // Normal part of the sentence.
  final String text;

  // Clickable part.
  final String actionText;

  // Action performed when the clickable text is pressed.
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
      // Row uses only the space needed by the texts.
      mainAxisSize: MainAxisSize.min,

      // Keeps Arabic text order correct.
      textDirection: TextDirection.rtl,

      children: [
        Text(
          text,
          style: AppTextStyles.secondaryText,
        ),
        GestureDetector(
          // Only the action text is clickable.
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
