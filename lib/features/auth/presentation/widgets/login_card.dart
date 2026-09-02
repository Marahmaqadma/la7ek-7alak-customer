import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../data/models/login/login_request_body.dart';
import '../cubit/login/login_cubit.dart';
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
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginType selectedType = LoginType.consumer;
  bool _isPasswordObscured = true;

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
      constraints: BoxConstraints(minHeight: 530.h),

      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),

      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),

      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.loginResponse.message)),
            );
          } else if (state is LoginError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------------- TITLE ----------------
                Text('تسجيل الدخول', style: AppTextStyles.screenTitle),

                SizedBox(height: 4.h),

                Text('سجل دخولك للمتابعة', style: AppTextStyles.screenSubtitle),

                SizedBox(height: 18.h),

                // ---------------- EMAIL ----------------
                Text('البريد الإلكتروني', style: AppTextStyles.fieldLabel),

                SizedBox(height: 5.h),

                CustomTextField(
                  controller: emailController,
                  hintText: 'alaa@example.com',
                  keyboardType: TextInputType.emailAddress,
                  underlineHint: true,
                  textDirection: TextDirection.ltr,
                  validator: Validators.email,
                ),

                SizedBox(height: 12.h),

                // ---------------- PASSWORD ----------------
                Text('كلمة المرور', style: AppTextStyles.fieldLabel),

                SizedBox(height: 5.h),

                CustomTextField(
                  controller: passwordController,
                  hintText: '••••••••••',
                  obscureText: _isPasswordObscured,
                  validator: Validators.password,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isPasswordObscured = !_isPasswordObscured;
                      });
                    },
                    icon: Icon(
                      _isPasswordObscured
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 21.sp,
                      color: AppColors.darkBrown,
                    ),
                  ),
                ),

                SizedBox(height: 8.h),

                // ---------------- LOGIN BUTTON ----------------
                Center(
                  child: state is LoginLoading
                      ? const CircularProgressIndicator()
                      : CustomButton.dark(
                          text: 'تسجيل الدخول',
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<LoginCubit>().login(
                                    LoginRequestBody(
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim(),
                                    ),
                                  );
                            }
                          },
                        ),
                ),

                SizedBox(height: 8.h),

                // ---------------- FORGOT PASSWORD ----------------
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context, AppRouter.sendVerificationCode);
                    },
                    child: Text('نسيت كلمة المرور؟',
                        style: AppTextStyles.linkText),
                  ),
                ),

                SizedBox(height: 26.h),

                // ---------------- LOGIN TYPE TITLE ----------------
                Row(
                  children: [
                    const Expanded(
                      child: Divider(color: AppColors.divider, thickness: 1),
                    ),
                    SizedBox(width: 10.w),
                    Text('اختر نوع الدخول',
                        style: AppTextStyles.loginTypeLabel),
                    SizedBox(width: 10.w),
                    const Expanded(
                      child: Divider(color: AppColors.divider, thickness: 1),
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
                    onTap: () {
                      Navigator.pushNamed(context, AppRouter.register);
                    },
                  ),
                ),

                SizedBox(height: 20.h),

                // ---------------- ADMIN ----------------
                Center(
                  child: GestureDetector(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        widget.onAdminLogin();
                      }
                    },
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
        },
      ),
    );
  }
}
