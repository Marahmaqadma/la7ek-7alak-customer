import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// زر الإعجاب (يمين) وزر المشاركة داخل دائرة (يسار) أسفل شاشة القصة.
// حالة الإعجاب تأتي من الخارج، والضغط يُبلّغ للخارج.
class StoryBottomActionsWidget extends StatelessWidget {
  final bool isLiked;
  final VoidCallback onLikeTap;
  final VoidCallback onShareTap;

  const StoryBottomActionsWidget({
    super.key,
    required this.isLiked,
    required this.onLikeTap,
    required this.onShareTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onLikeTap,
          icon: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked ? Colors.red : Colors.white,
            size: 24.sp,
          ),
        ),
        Material(
          color: Colors.white.withOpacity(0.2),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onShareTap,
            child: SizedBox(
              width: 34.w,
              height: 34.w,
              child: Icon(
                Icons.share_outlined,
                color: Colors.white,
                size: 18.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
