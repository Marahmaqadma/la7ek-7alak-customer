import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      "سيتم إرسال كود التحقق عبر الإيميل",
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
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // New Password Field
                          _buildLabel("كلمة المرور الجديدة"),
                          SizedBox(height: 8.h),
                          _buildPasswordField(
                            controller: _newPasswordController,
                            obscureText: _obscureNewPassword,
                            onToggle: () {
                              setState(() {
                                _obscureNewPassword = !_obscureNewPassword;
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
                            onToggle: () {
                              setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword;
                              });
                            },
                          ),
                          SizedBox(height: 20.h),
                          // Validation Hints
                          _buildValidationItem("يجب أن تحتوي كلمة المرور على 8 خانات (حروف , أرقام , رموز)."),
                          SizedBox(height: 8.h),
                          _buildValidationItem("يجب تطابق كلمتي المرور."),
                          SizedBox(height: 30.h),
                          // Submit Button
                          SizedBox(
                            width: 270.w,
                            height: 42.h,
                            child: ElevatedButton(
                              onPressed: () {
                                // Action
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2C1A14),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
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
    required VoidCallback onToggle,
  }) {
    return Container(
      width: 270.w,
      height: 42.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF9F3EA),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFE0825B), width: 1),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        textAlign: TextAlign.start,
        style: TextStyle(fontSize: 14.sp),
        decoration: InputDecoration(
          hintText: "••••••••",
          hintStyle: TextStyle(
            color: const Color(0xFFA0A0A0),
            fontSize: 14.sp,
            letterSpacing: 2,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          border: InputBorder.none,
          suffixIcon: GestureDetector(
            onTap: onToggle,
            child: Icon(
              obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
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

  Widget _buildValidationItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.check_box,
          size: 16.sp,
          color: const Color(0xFFC05A34),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 10.sp,
              color: const Color(0xFFC05A34),
              fontWeight: FontWeight.w300, // Matching 350 approx
            ),
          ),
        ),
      ],
    );
  }
}
