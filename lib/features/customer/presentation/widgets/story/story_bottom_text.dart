import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// نص القصة أسفل الشاشة.
class StoryBottomTextWidget extends StatelessWidget {
  final String text;

  const StoryBottomTextWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontFamily: 'Tajawal',
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        height: 1.3,
      ),
    );
  }
}
