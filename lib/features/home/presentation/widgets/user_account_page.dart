import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../cubit/home_cubit.dart';
import 'user_account_cards.dart';
import 'user_profile_header.dart';

// يجمع الصورة والاسم والمدينة وبطاقات الحساب وزر الخروج.
class UserAccountPage extends StatelessWidget {
  final HomeState state;
  final ValueChanged<ImageSource> onPickProfileImage;
  final VoidCallback onLogout;

  const UserAccountPage({
    super.key,
    required this.state,
    required this.onPickProfileImage,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserProfileHeader(
          fullName: state.fullName,
          city: state.city,
          imagePath: state.profileImagePath,
          onAddPhoto: () => _showImageSourceSheet(context),
        ),
        SizedBox(height: 28.h),
        const PhoneVerificationCard(),
        SizedBox(height: 18.h),
        FollowedStoresCard(
          count: state.followedStoresCount,
          city: state.city,
        ),
        SizedBox(height: 18.h),
        LogoutButton(onTap: onLogout),
      ],
    );
  }

  // يفتح قائمة سفلية لاختيار الكاميرا أو معرض الصور.
  void _showImageSourceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
      ),
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ImageSourceOption(
                  icon: Icons.photo_library_outlined,
                  title: 'اختيار من المعرض',
                  source: ImageSource.gallery,
                  onSelected: onPickProfileImage,
                ),
                _ImageSourceOption(
                  icon: Icons.photo_camera_outlined,
                  title: 'فتح الكاميرا',
                  source: ImageSource.camera,
                  onSelected: onPickProfileImage,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// يغلق قائمة الصور ثم يرسل اختيار الكاميرا أو المعرض إلى الصفحة.
class _ImageSourceOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final ImageSource source;
  final ValueChanged<ImageSource> onSelected;

  const _ImageSourceOption({
    required this.icon,
    required this.title,
    required this.source,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.pop(context);
        onSelected(source);
      },
      leading: Icon(
        icon,
        color: AppColors.orange,
        size: 22.sp,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.darkBrown,
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
