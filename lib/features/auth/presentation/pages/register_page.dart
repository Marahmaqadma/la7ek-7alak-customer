import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/utils/validators.dart';
import '../../data/models/register_request_body.dart';
import '../cubit/register/register_cubit.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

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
  // State
  String? _selectedCity;
  bool _phoneValid = false;
  bool _emailValid = false;
  bool _passwordValid = false;
  bool _isPasswordObscured = true; // تعني أن كلمة المرور مشفرة مبدئياً
  @override
  void initState() {
    super.initState();

    // Listener البريد الإلكتروني
    _emailController.addListener(() {
      final isValid = Validators.isEmailValid(_emailController.text);
      if (_emailValid != isValid) {
        setState(() {
          _emailValid = isValid;
        });
      }
    });

    // Listener رقم الهاتف
    _phoneController.addListener(() {
      final isValid = Validators.isPhoneValid(_phoneController.text);
      if (_phoneValid != isValid) {
        setState(() {
          _phoneValid = isValid;
        });
      }
    });

    // Listener كلمة المرور
    _passwordController.addListener(() {
      final isValid = Validators.isPasswordValid(_passwordController.text);
      if (_passwordValid != isValid) {
        setState(() {
          _passwordValid = isValid;
        });
      }
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.registerResponse.message)),
          );
          Navigator.pushReplacementNamed(context, AppRouter.login);
        } else if (state is RegisterError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: scaffoldBg,
          body: SafeArea(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
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
                              left: 110.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          'حساب جديد',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 22.sp,
                                            fontWeight: FontWeight.w800,
                                            color: mainTitleColor,
                                          ),
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
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 28.h,
                        ),
                        decoration: BoxDecoration(
                          color: innerFormBg,
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _buildInputField(
                                label: 'الاسم الكامل',
                                hint: 'آلاء حسين',
                                controller: _fullNameController,
                                validator: Validators.fullName,
                              ),
                              SizedBox(height: 12.h),
                              _buildInputField(
                                label: 'البريد الإلكتروني',
                                hint: 'alaa@gmail.com',
                                controller: _emailController,
                                validator: Validators.email,
                                showCheck: true,
                                isChecked: _emailValid,
                                keyboardType: TextInputType.emailAddress,
                                textDirection: TextDirection.ltr,
                              ),
                              SizedBox(height: 12.h),
                              _buildInputField(
                                label: 'رقم الهاتف (للتوثيق)',
                                hint: '\u200E 059 000 0000',
                                controller: _phoneController,
                                validator: Validators.phone,
                                helperText: '.يجب ان يحتوي على 10 خانات',
                                showCheck: true,
                                isChecked: _phoneValid,
                                keyboardType: TextInputType.phone,
                                textDirection: TextDirection.ltr,
                                textAlign: TextAlign.right,
                              ),
                              SizedBox(height: 12.h),
                              _buildInputField(
                                label: 'كلمة المرور',
                                hint: '********',
                                controller: _passwordController,
                                validator: Validators.password,
                                isPassword: _isPasswordObscured,
                                helperText:
                                    'يجب أن تحتوي كلمة المرور على 8 خانات (حروف , أرقام , رموز).',
                                showCheck: true,
                                isChecked: _passwordValid,
                                onCheckTap: null,
                                onEyeTap: () {
                                  // تم إضافة دالة الضغط على العين هنا
                                  setState(() {
                                    _isPasswordObscured = !_isPasswordObscured;
                                  });
                                },
                              ),
                              SizedBox(height: 12.h),
                              _buildDropdownField(
                                label: 'المدينة أو المنطقة',
                                hint: 'اختر مدينتك',
                              ),
                              SizedBox(height: 40.h),
                              // Action Button
                              if (state is RegisterLoading)
                                const Center(child: CircularProgressIndicator())
                              else
                                SizedBox(
                                  width: double.infinity,
                                  height: 55.h,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        context.read<RegisterCubit>().register(
                                              RegisterRequestBody(
                                                fullName: _fullNameController
                                                    .text
                                                    .trim(),
                                                email: _emailController.text
                                                    .trim(),
                                                password: _passwordController
                                                    .text
                                                    .trim(),
                                                role: 'consumer',
                                                phone: _phoneController.text
                                                    .trim(),
                                              ),
                                            );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryButtonColor,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.r),
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
                              Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    ' لديك حساب بالفعل؟ ',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color:
                                          mainTitleColor.withValues(alpha: 0.9),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, AppRouter.login);
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
                      ),
                      SizedBox(height: 30.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    String? helperText,
    FormFieldValidator<String>? validator,
    bool isPassword = false,
    bool showCheck = false,
    bool isChecked = false,
    VoidCallback? onCheckTap,
    TextDirection? textDirection,
    VoidCallback? onEyeTap,
    TextAlign textAlign = TextAlign.right,
    TextInputType? keyboardType,
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
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: hintTextColor, fontSize: 14.sp),
            filled: true,
            fillColor: inputFillColor,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 10.h,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: inputBorderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: inputBorderColor),
            ),
            prefixIcon: isPassword
                ? Icon(
                    Icons.lock,
                    size: 18.sp,
                    color: mainTitleColor,
                  ) // Composite-style lock icon
                : null,
            suffixIcon: onEyeTap != null
                ? IconButton(
                    icon: Icon(
                      // هنا السحر! إذا كانت مخفية أظهر عين مغلقة، وإذا كانت مرئية أظهر عين مفتوحة
                      isPassword
                          ? Icons
                              .visibility_off_outlined // الأيقونة الحالية: مخفية
                          : Icons
                              .visibility_outlined, // الأيقونة الجديدة: مرئية
                      size: 20.sp,
                      color: hintTextColor,
                    ),
                    onPressed:
                        onEyeTap, // هذا لربط الضغطة بالدالة التي تعكس الحالة
                  )
                : null,
            errorMaxLines: 2,
            errorStyle: TextStyle(
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
                        isChecked
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
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
        FormField<String>(
          initialValue: _selectedCity,
          validator: Validators.city,
          builder: (field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => Directionality(
                        textDirection: TextDirection.rtl,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            'شمال غزة',
                            'مدينة غزة',
                            'النصيرات',
                            'دير البلح',
                            'المغازي',
                            'البريج',
                            'خانيونس',
                          ]
                              .map(
                                (city) => ListTile(
                                  title: Text(city),
                                  onTap: () {
                                    setState(() => _selectedCity = city);
                                    field.didChange(city);
                                    Navigator.pop(context);
                                  },
                                ),
                              )
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
                      border: Border.all(
                        color: field.hasError ? subtextColor : inputBorderColor,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedCity ?? hint,
                          style: TextStyle(
                            color: _selectedCity != null
                                ? mainTitleColor
                                : hintTextColor,
                            fontSize: 14.sp,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: mainTitleColor,
                          size: 28.sp,
                        ),
                      ],
                    ),
                  ),
                ),
                if (field.hasError)
                  Padding(
                    padding: EdgeInsets.only(top: 6.h),
                    child: Text(
                      field.errorText!,
                      style: TextStyle(
                        color: subtextColor,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
