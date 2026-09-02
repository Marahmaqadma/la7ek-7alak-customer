import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/validators.dart';
import '../../data/models/reset_password/reset_password_request_body.dart';
import '../cubit/reset_password/reset_password_cubit.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;

  const ResetPasswordPage({
    super.key,
    required this.email,
  });

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(() {
      setState(() {});
    });
    _confirmPasswordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) {
        if (state is ResetPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.resetPasswordResponse.message ??
                    'تم تغيير كلمة المرور بنجاح',
              ),
            ),
          );
        } else if (state is ResetPasswordError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFFDF8EE),
          body: SafeArea(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.h),
                  child: Center(
                    child: Column(
                      children: [
                        // Header Logo
                        Image.asset(
                          'assets/images/logo.png',
                          width: 108.w,
                          height: 108.h,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 16.h),
                        // Title
                        Text(
                          "استعادة كلمة المرور",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2C1A14),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        // Subtitle
                        Text(
                          "",
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFFC05A34),
                          ),
                        ),
                        SizedBox(height: 30.h),
                        // Main Card
                        Container(
                          width: 310.w,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 30.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // New Password Field
                                _buildLabel("كلمة المرور الجديدة"),
                                SizedBox(height: 8.h),
                                _buildPasswordField(
                                  controller: _newPasswordController,
                                  obscureText: _obscureNewPassword,
                                  validator: Validators.password,
                                  onToggle: () {
                                    setState(() {
                                      _obscureNewPassword =
                                          !_obscureNewPassword;
                                    });
                                  },
                                ),
                                SizedBox(height: 20.h),
                                // Confirm Password Field
                                _buildLabel("تأكيد كلمة المرور الجديدة"),
                                SizedBox(height: 8.h),
                                _buildPasswordField(
                                  controller: _confirmPasswordController,
                                  obscureText: _obscureConfirmPassword,
                                  validator: (value) =>
                                      Validators.confirmPassword(
                                    value,
                                    _newPasswordController.text,
                                  ),
                                  onToggle: () {
                                    setState(() {
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword;
                                    });
                                  },
                                ),
                                SizedBox(height: 20.h),
                                // Validation Hints
                                _buildValidationItem(
                                  "يجب أن تحتوي كلمة المرور على 8 خانات (حروف , أرقام , رموز).",
                                  isValid:
                                      _newPasswordController.text.length >= 8,
                                ),
                                SizedBox(height: 8.h),
                                _buildValidationItem(
                                  "يجب تطابق كلمتي المرور.",
                                  isValid:
                                      _newPasswordController.text.isNotEmpty &&
                                          _newPasswordController.text ==
                                              _confirmPasswordController.text,
                                ),

                                SizedBox(height: 30.h),
                                // Submit Button
                                if (state is ResetPasswordLoading)
                                  const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                else
                                  SizedBox(
                                    width: 270.w,
                                    height: 42.h,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          context
                                              .read<ResetPasswordCubit>()
                                              .resetPassword(
                                                ResetPasswordRequestBody(
                                                  email: widget.email,
                                                  newPassword:
                                                      _newPasswordController
                                                          .text
                                                          .trim(),
                                                ),
                                              );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF2C1A14),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                      ),
                                      child: Text(
                                        "تأكيد كلمة المرور الجديدة",
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF2C1A14),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required bool obscureText,
    required FormFieldValidator<String> validator,
    required VoidCallback onToggle,
  }) {
    return Container(
      width: 270.w,
      constraints: BoxConstraints(minHeight: 42.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F3EA),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFE0825B), width: 1),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        textAlign: TextAlign.start,
        style: TextStyle(fontSize: 14.sp),
        decoration: InputDecoration(
          hintText: "••••••••",
          hintStyle: TextStyle(
            color: const Color(0xFFA0A0A0),
            fontSize: 14.sp,
            letterSpacing: 2,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 10.h,
          ),
          border: InputBorder.none,
          errorMaxLines: 2,
          errorStyle: TextStyle(
            color: const Color(0xFFC05A34),
            fontSize: 10.sp,
            height: 0.8,
          ),
          suffixIcon: GestureDetector(
            onTap: onToggle,
            child: Icon(
              obscureText
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 20.sp,
              color: const Color(0xFF2C1A14),
            ),
          ),
          prefixIcon: Icon(
            Icons.lock_outline,
            size: 20.sp,
            color: const Color(0xFF2C1A14),
          ),
        ),
      ),
    );
  }

  Widget _buildValidationItem(String text, {bool isValid = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          // تبديل شكل الأيقونة فقط: مربع محدد عند الصحة، ومربع فارغ عند الخطأ
          isValid ? Icons.check_box : Icons.check_box_outline_blank,
          size: 16.sp,
          color: const Color(0xFFC05A34), // اللون ثابت دائماً
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 10.sp,
              color: const Color(0xFFC05A34), // اللون ثابت دائماً
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }
}
