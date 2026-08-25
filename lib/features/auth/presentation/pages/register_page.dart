import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'login_page.dart';
import '../../../../core/routing/app_router.dart';
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Color Palette
  static const Color scaffoldBg = Color(0xFFF5EFE6);
  static const Color innerFormBg = Colors.white;
  static const Color inputFillColor = Color(0xFFFAF7F2);
  static const Color inputBorderColor = Color(0xFFE5E0D8);
  static const Color primaryButtonColor = Color(0xFF2C1A14);
  static const Color mainTitleColor = Color(0xFF2C1A14);
  static const Color subtextColor = Color(0xFF7E361B);
  static const Color hintTextColor = Color(0xFFA0A0A0);

  // Controllers
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  // State
  String? _selectedCity;
  bool _phoneValid = true;
  bool _passwordValid = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  // Header section using Stack for absolute positioning
                  SizedBox(
                    height: 100.h,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Logo Positioned at the extreme top right corner
                        Positioned(
                          top: -15.h,
                          left: -25.w,
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: 100.w,
                            height: 100.h,
                            fit: BoxFit.contain,
                          ),
                        ),
                        // Title & Subtitle Positioned centered in the remaining space
                        Positioned(
                          top: 20.h,
                          right: 10.w,
                          left:110.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'حساب جديد',
                                    style: TextStyle(
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.w800,
                                      color: mainTitleColor,
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Icon(
                                    Icons.person,
                                    color: const Color(0xFF7A8D9C),
                                    size: 24.sp,
                                  ),
                                ],
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'انضم واستفد من العروض قبل انتهاء مؤقتها',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: subtextColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 0.h), // Spacing adjusted by Stack

                  // Inner Form Container
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 28.h),
                    decoration: BoxDecoration(
                      color: innerFormBg,
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Column(
                      children: [
                        _buildInputField(
                          label: 'الاسم الكامل',
                          hint: 'آلاء حسين',
                          controller: _fullNameController,
                        ),
                        SizedBox(height: 12.h),
                        _buildInputField(
                          label: 'البريد الإلكتروني',
                          hint: 'alaa@gmail.com',
                          controller: _emailController,
                          errorText: 'البريد مسجل مسبقا او غير صالح.',
                        ),
                        SizedBox(height: 12.h),
                        _buildInputField(
                          label: 'رقم الهاتف (للتوثيق)',
                          hint: '\u200E+970 590 000 000',
                          controller: _phoneController,
                          helperText: 'يجب ان يحتوي على 10 خانات.',
                          showCheck: true,
                          isChecked: _phoneValid,
                          onCheckTap: () => setState(() => _phoneValid = !_phoneValid),
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.right,
                        ),
                        SizedBox(height: 12.h),
                        _buildInputField(
                          label: 'كلمة المرور',
                          hint: '********',
                          controller: _passwordController,
                          isPassword: true,
                          helperText: 'يجب أن تحتوي كلمة المرور على 8 خانات (حروف , أرقام , رموز).',
                          showCheck: true,
                          isChecked: _passwordValid,
                          onCheckTap: () => setState(() => _passwordValid = !_passwordValid),
                        ),
                        SizedBox(height: 12.h),
                        _buildDropdownField(
                          label: 'المدينة أو المنطقة',
                          hint: 'اختر مدينتك',
                        ),
                        SizedBox(height: 40.h),
                        // Action Button
                        SizedBox(
                          width: double.infinity,
                          height: 55.h,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryButtonColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'إنشاء الحساب والمتابعة',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        // Footer Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              ' لديك حساب بالفعل؟ ',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: mainTitleColor.withOpacity(0.9),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginPage()),
                              );
                              },
                              child: Text(
                                'تسجيل الدخول',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: subtextColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    String? errorText,
    String? helperText,
    bool isPassword = false,
    bool showCheck = false,
    bool isChecked = false,
    VoidCallback? onCheckTap,
    TextDirection? textDirection,
    TextAlign textAlign = TextAlign.right,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: mainTitleColor,
          ),
        ),
        SizedBox(height: 4.h),
        TextFormField(
          controller: controller,
          textAlign: textAlign,
          obscureText: isPassword,
          textDirection: textDirection,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: hintTextColor,
              fontSize: 14.sp,
            ),
            filled: true,
            fillColor: inputFillColor,
            contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: inputBorderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: inputBorderColor),
            ),
            prefixIcon: isPassword
                ? Icon(Icons.lock, size: 18.sp, color: mainTitleColor) // Composite-style lock icon
                : null,
            suffixIcon: isPassword
                ? Icon(Icons.visibility_off_outlined, size: 20.sp, color: hintTextColor)
                : null,
          ),
        ),
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(top: 6.h),
            child: Text(
              errorText,
              style: TextStyle(
                color: subtextColor,
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        if (helperText != null)
          Padding(
            padding: EdgeInsets.only(top: 6.h),
            child: Row(
              children: [
                if (showCheck)
                  GestureDetector(
                    onTap: onCheckTap,
                    child: Padding(
                      padding: EdgeInsets.only(left: 4.w),
                      child: Icon(
                        isChecked ? Icons.check_box : Icons.check_box_outline_blank,
                        color: subtextColor,
                        size: 18.sp,
                      ),
                    ),
                  ),
                Expanded(
                  child: Text(
                    helperText,
                    maxLines: 1, // Single line only
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: subtextColor,
                      fontSize: 10.sp, // Reduced font size
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildDropdownField({required String label, required String hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: mainTitleColor,
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => Directionality(
                textDirection: TextDirection.rtl,
                child: ListView(
                  shrinkWrap: true,
                  children: ['شمال غزة', 'مدينة غزة', 'النصيرات', 'دير البلح', 'المغازي', 'البريج', 'خانيونس']
                      .map((city) => ListTile(
                            title: Text(city),
                            onTap: () {
                              setState(() => _selectedCity = city);
                              Navigator.pop(context);
                            },
                          ))
                      .toList(),
                ),
              ),
            );
          },
          child: Container(
            height: 52.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: inputFillColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: inputBorderColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedCity ?? hint,
                  style: TextStyle(
                    color: _selectedCity != null ? mainTitleColor : hintTextColor,
                    fontSize: 14.sp,
                  ),
                ),
                Icon(Icons.keyboard_arrow_down, color: mainTitleColor, size: 28.sp),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
