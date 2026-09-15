import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/utils/validators.dart';
import 'register_input_field.dart';
import 'register_dropdown_field.dart';
import 'register_actions_widget.dart';

// يجمع بيانات الحساب وتأكيد كلمة المرور والمدينة وزر التسجيل.
class RegisterFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final String? selectedCity;
  final bool emailValid;
  final bool phoneValid;
  final bool passwordValid;
  final bool confirmPasswordValid;
  final bool isPasswordObscured;
  final bool isConfirmPasswordObscured;
  final Function(String?) onCitySelected;
  final VoidCallback onEyeTapPassword;
  final VoidCallback onEyeTapConfirmPassword;
  final VoidCallback onSubmit;
  final bool isLoading;

  const RegisterFormWidget({
    super.key,
    required this.formKey,
    required this.fullNameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.selectedCity,
    required this.emailValid,
    required this.phoneValid,
    required this.passwordValid,
    required this.confirmPasswordValid,
    required this.isPasswordObscured,
    required this.isConfirmPasswordObscured,
    required this.onCitySelected,
    required this.onEyeTapPassword,
    required this.onEyeTapConfirmPassword,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 28.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            RegisterInputField(
              // بيانات تعريف الحساب التي سيرسلها النموذج إلى خدمة التسجيل.
              label: 'الاسم',
              hint: 'ayazanean',
              controller: fullNameController,
              validator: Validators.fullName,
            ),
            SizedBox(height: 12.h),
            RegisterInputField(
              label: 'البريد الإلكتروني',
              hint: 'ayaayaaya@gmail.com',
              controller: emailController,
              validator: Validators.email,
              helperText: 'البريد مسجل مسبقا او غير صالح.',
              showCheck: true,
              isChecked: emailValid,
              keyboardType: TextInputType.emailAddress,
              textDirection: TextDirection.ltr,
            ),
            SizedBox(height: 12.h),
            RegisterInputField(
              label: 'رقم الهاتف',
              hint: '000 000 0590',
              controller: phoneController,
              validator: Validators.phone,
              showCheck: true,
              isChecked: phoneValid,
              keyboardType: TextInputType.phone,
              textDirection: TextDirection
                  .ltr,
              textAlign: TextAlign
                  .right,
            ),
            SizedBox(height: 12.h),
            RegisterInputField(
              label: 'كلمة المرور',
              hint: '************',
              controller: passwordController,
              validator: Validators.password,
              helperText:
                  'يجب أن تحتوي كلمة المرور على 8 خانات (حروف ، أرقام).',
              showCheck: true,
              isChecked: passwordValid,
              isPassword: isPasswordObscured,
              onEyeTap: onEyeTapPassword,
            ),
            SizedBox(height: 12.h),
            RegisterInputField(
              // التأكيد للتحقق داخل الواجهة فقط؛ لا يُرسل كحقل مستقل إلى الخدمة.
              label: 'تأكيد كلمة المرور',
              hint: '************',
              controller: confirmPasswordController,
              validator: (value) =>
                  Validators.confirmPassword(value, passwordController.text),
              helperText: 'يجب أن تتطابق كلمة المرور.',
              showCheck: true,
              isChecked: confirmPasswordValid,
              isPassword: isConfirmPasswordObscured,
              onEyeTap: onEyeTapConfirmPassword,
            ),
            SizedBox(height: 12.h),
            // اختيار المدينة مطلوب قبل السماح بتسجيل الحساب.
            RegisterDropdownField(
              label: 'المدينة',
              hint: 'اختر مدينتك',
              selectedCity: selectedCity,
              onCitySelected: onCitySelected,
            ),
            SizedBox(height: 30.h),
            // استبدال زر الإرسال بمؤشر تحميل أثناء انتظار الطلب.
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else
              RegisterSubmitButton(onPressed: onSubmit),
            SizedBox(height: 20.h),
            const RegisterFooterWidget(),
          ],
        ),
      ),
    );
  }
}
