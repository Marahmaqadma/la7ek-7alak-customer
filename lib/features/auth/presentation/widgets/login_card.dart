import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_text_field.dart';
import 'auth_link_text.dart';
import 'login_type_card.dart';

class LoginCard extends StatefulWidget {
  final VoidCallback onForgotPassword;
  final VoidCallback onCreateAccount;
  final VoidCallback onAdminLogin;

  const LoginCard({
    super.key,
    required this.onForgotPassword,
    required this.onCreateAccount,
    required this.onAdminLogin,
  });

  @override
  State<LoginCard> createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginType selectedType = LoginType.consumer;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Figma width.
      width: 310.w,

      // Minimum Figma height.
      // We do NOT force the height because that caused your overflow.
      constraints: BoxConstraints(
        minHeight: 530.h,
      ),

      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 20.h,
      ),

      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------- TITLE ----------------

          Text(
            'تسجيل الدخول',
            style: AppTextStyles.screenTitle,
          ),

          SizedBox(height: 4.h),

          Text(
            'سجل دخولك للمتابعة',
            style: AppTextStyles.screenSubtitle,
          ),

          SizedBox(height: 18.h),

          // ---------------- EMAIL ----------------

          Text(
            'البريد الإلكتروني',
            style: AppTextStyles.fieldLabel,
          ),

          SizedBox(height: 5.h),

          CustomTextField(
            controller: emailController,
            hintText: 'alaa@example.com',
            keyboardType: TextInputType.emailAddress,
            underlineHint: true,
          ),

          SizedBox(height: 12.h),

          // ---------------- PASSWORD ----------------

          Text(
            'كلمة المرور',
            style: AppTextStyles.fieldLabel,
          ),

          SizedBox(height: 5.h),

          CustomTextField(
            controller: passwordController,
            hintText: '••••••••••',
            obscureText: true,
            suffixIcon: Icon(
              Icons.remove_red_eye_outlined,
              size: 21.sp,
              color: AppColors.darkBrown,
            ),
          ),

          SizedBox(height: 8.h),

          // ---------------- FORGOT PASSWORD ----------------

          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: widget.onForgotPassword,
              child: Text(
                'نسيت كلمة المرور؟',
                style: AppTextStyles.linkText,
              ),
            ),
          ),

          SizedBox(height: 26.h),

          // ---------------- LOGIN TYPE TITLE ----------------

          Row(
            children: [
              const Expanded(
                child: Divider(
                  color: AppColors.divider,
                  thickness: 1,
                ),
              ),

              SizedBox(width: 10.w),

              Text(
                'اختر نوع الدخول',
                style: AppTextStyles.loginTypeLabel,
              ),

              SizedBox(width: 10.w),

              const Expanded(
                child: Divider(
                  color: AppColors.divider,
                  thickness: 1,
                ),
              ),
            ],
          ),

          SizedBox(height: 15.h),

          // ---------------- CONSUMER / MERCHANT ----------------

          Row(
            // Figma has Consumer on the left
            // and Merchant on the right.
            textDirection: TextDirection.ltr,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LoginTypeCard(
                title: 'الدخول كمستهلك',
                subtitle: 'تصفح العروض واستمتع بالتوفير',
                icon: Icons.person_outline,
                isSelected: selectedType == LoginType.consumer,
                onTap: () {
                  setState(() {
                    selectedType = LoginType.consumer;
                  });
                },
              ),

              LoginTypeCard(
                title: 'الدخول كتاجر',
                subtitle: 'إدارة متجرك وعروضك',
                icon: Icons.storefront_outlined,
                isSelected: selectedType == LoginType.merchant,
                onTap: () {
                  setState(() {
                    selectedType = LoginType.merchant;
                  });
                },
              ),
            ],
          ),

          SizedBox(height: 18.h),

          // ---------------- CREATE ACCOUNT ----------------

          Center(
            child: AuthLinkText(
              text: 'ليس لديك حساب؟ ',
              actionText: 'إنشاء حساب جديد',
              onTap: widget.onCreateAccount,
            ),
          ),

          SizedBox(height: 20.h),

          // ---------------- ADMIN ----------------

          Center(
            child: GestureDetector(
              onTap: widget.onAdminLogin,
              child: Container(
                width: 130.w,
                height: 26.h,
                alignment: Alignment.center,

                decoration: BoxDecoration(
                  color: AppColors.adminBackground,
                  borderRadius: BorderRadius.circular(13.r),
                ),

                child: Text(
                  'الدخول ك أدمن',
                  style: AppTextStyles.adminButton,
                ),
              ),
            ),
          ),

          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}