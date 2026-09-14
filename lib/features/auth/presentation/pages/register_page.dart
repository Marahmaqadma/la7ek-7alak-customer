import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/validators.dart';
import '../../../../core/theme/app_colors.dart';

import 'package:la7ek_7alak/features/auth/presentation/widgets/register_widgets/register_header_widget.dart';
import 'package:la7ek_7alak/features/auth/presentation/widgets/register_widgets/register_background_widget.dart';
import 'package:la7ek_7alak/features/auth/presentation/widgets/register_widgets/register_form_widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _selectedCity;
  bool _phoneValid = false;
  bool _emailValid = false;
  bool _passwordValid = false;
  bool _confirmPasswordValid = false; // متغير فحص التطابق
  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  @override
  void initState() {
    super.initState();

    _emailController.addListener(() {
      final isValid = Validators.isEmailValid(_emailController.text);
      if (_emailValid != isValid) setState(() => _emailValid = isValid);
    });

    _phoneController.addListener(() {
      final isValid = Validators.isPhoneValid(_phoneController.text);
      if (_phoneValid != isValid) setState(() => _phoneValid = isValid);
    });

    // فحص كلمة المرور لحظياً
    _passwordController.addListener(() {
      final passwordValid = Validators.isPasswordValid(_passwordController.text);
      final confirmValid = _confirmPasswordController.text.isNotEmpty &&
          _confirmPasswordController.text == _passwordController.text;

      if (_passwordValid != passwordValid || _confirmPasswordValid != confirmValid) {
        setState(() {
          _passwordValid = passwordValid;
          _confirmPasswordValid = confirmValid;
        });
      }
    });

    // فحص تطابق كلمة المرور لحظياً
    _confirmPasswordController.addListener(() {
      final confirmValid = _confirmPasswordController.text.isNotEmpty &&
          _confirmPasswordController.text == _passwordController.text;
      if (_confirmPasswordValid != confirmValid) {
        setState(() => _confirmPasswordValid = confirmValid);
      }
    });
  }
  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.adminBackground,
      body: Stack(
        children: [
          const RegisterBackgroundWidget(),
          SafeArea(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: Column(
                    children: [
                      SizedBox(height: 15.h),
                      SizedBox(
                        width: 340.w,
                        child: const RegisterHeaderWidget(),
                      ),
                      SizedBox(height: 15.h),
                      RegisterFormWidget(
                        formKey: _formKey,
                        fullNameController: _fullNameController,
                        emailController: _emailController,
                        phoneController: _phoneController,
                        passwordController: _passwordController,
                        confirmPasswordController: _confirmPasswordController,
                        selectedCity: _selectedCity,
                        emailValid: _emailValid,
                        phoneValid: _phoneValid,
                        passwordValid: _passwordValid,
                        confirmPasswordValid: _confirmPasswordValid,
                        isPasswordObscured: _isPasswordObscured,
                        isConfirmPasswordObscured: _isConfirmPasswordObscured,
                        onCitySelected: (city) => setState(() => _selectedCity = city),
                        onEyeTapPassword: () => setState(() => _isPasswordObscured = !_isPasswordObscured),
                        onEyeTapConfirmPassword: () => setState(() => _isConfirmPasswordObscured = !_isConfirmPasswordObscured),
                        onSubmit: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('تم التحقق من الحقول بنجاح!')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
