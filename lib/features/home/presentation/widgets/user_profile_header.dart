import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';

// يعرض اسم المستخدم ومدينته وصورته مع زر تغيير الصورة.
class UserProfileHeader extends StatelessWidget {
  final String fullName;
  final String city;
  final String? imagePath;
  final VoidCallback onAddPhoto;

  const UserProfileHeader({
    super.key,
    required this.fullName,
    required this.city,
    required this.imagePath,
    required this.onAddPhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileAvatar(
          imagePath: imagePath,
          onAddPhoto: onAddPhoto,
        ),
        SizedBox(height: 11.h),
        Text(
          fullName,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.darkBrown,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
        SizedBox(height: 6.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on,
              color: AppColors.orange,
              size: 12.sp,
            ),
            SizedBox(width: 4.w),
            Text(
              city,
              style: TextStyle(
                color: AppColors.orange,
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                height: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// إطار الصورة الشخصية مع زر إضافة صورة.
class ProfileAvatar extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onAddPhoto;

  const ProfileAvatar({
    super.key,
    required this.imagePath,
    required this.onAddPhoto,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 118.w,
      height: 118.w,
      child: Stack(
        children: [
          Positioned.fill(
            child: InkWell(
              onTap: onAddPhoto,
              borderRadius: BorderRadius.circular(59.r),
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.orange,
                    width: 2.5.w,
                  ),
                ),
                child: ClipOval(child: _AvatarImage(imagePath: imagePath)),
              ),
            ),
          ),
          Positioned(
            right: 5.w,
            bottom: 5.h,
            child: AddPhotoButton(onTap: onAddPhoto),
          ),
        ],
      ),
    );
  }
}

// زر صغير لفتح خيارات إضافة الصورة الشخصية.
class AddPhotoButton extends StatelessWidget {
  final VoidCallback onTap;

  const AddPhotoButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: 30.w,
        height: 30.w,
        decoration: BoxDecoration(
          color: AppColors.orange,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.white,
            width: 2.w,
          ),
        ),
        child: Icon(
          Icons.add,
          color: AppColors.white,
          size: 20.sp,
        ),
      ),
    );
  }
}

// يعرض الصورة المحلية أو الرمز البديل عند غياب الصورة أو تعذر تحميلها.
class _AvatarImage extends StatelessWidget {
  final String? imagePath;

  const _AvatarImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    if (imagePath == null || !File(imagePath!).existsSync()) {
      return Container(
        color: const Color(0xFFEFF1F2),
        child: Icon(
          Icons.person,
          color: const Color(0xFF5B89A4),
          size: 56.sp,
        ),
      );
    }

    return Image.file(
      File(imagePath!),
      fit: BoxFit.cover,
    );
  }
}
