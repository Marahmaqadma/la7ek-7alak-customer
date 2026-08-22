import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constance/app_colors.dart';
import '../../constance/app_text_styles.dart';
import '../widgets/app_textfield.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fieldBackground,
      body: Directionality(

        //controls the direction of the arabic test
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            height: 780.h,

            //start the layering
            child: Stack(
              children: [

                // WHITE CARD
                Positioned(
                  top: 217.h,
                  left: 25.w,
                  right: 25.w,
                  child: Container(
                    height: 530.h,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(22.r),
                    ),
                  ),
                ),

                // LOGO
                Positioned(
                  top: 32.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Image.asset(
                      'lib/assets/images/logo.png',
                      width: 129.w,
                      height: 129.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // APP TITLE
                Positioned(
                  top: 143.h,
                  left: 0,
                  right: 0,
                  child: Text(
                    'لحّق حالك',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.appTitle,
                  ),
                ),

                // APP SUBTITLE
                Positioned(
                  top: 177.h,
                  left: 0,
                  right: 0,
                  child: Text(
                    'صفقات وفلاشات في الوقت الفعلي',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.tagline,
                  ),
                ),

                // LOGIN TITLE
                Positioned(
                  top: 236.h,
                  left: 45.w,
                  right: 45.w,
                  child: Text(
                    'تسجيل الدخول',
                    textAlign: TextAlign.right,
                    style: AppTextStyles.screenTitle,
                  ),
                ),

                // DESCRIPTION
                Positioned(
                  top: 262.h,
                  left: 45.w,
                  right: 45.w,
                  child: Text(
                    'أدخل بيانات حساب المستهلك للوصول للعروض القريبة',
                    textAlign: TextAlign.right,
                    style: AppTextStyles.description,
                  ),
                ),

                // EMAIL LABEL
                Positioned(
                  top: 315.h,
                  left: 45.w,
                  right: 45.w,
                  child: Text(
                    'البريد الإلكتروني / رقم الهاتف',
                    textAlign: TextAlign.right,
                    style: AppTextStyles.fieldLabel,
                  ),
                ),

                // EMAIL FIELD
                Positioned(
                  top: 336.h,
                  left: 45.w,
                  right: 45.w,
                  child: const AppTextField(
                    hintText: 'alaa@example.com',
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                // PASSWORD LABEL
                Positioned(
                  top: 389.h,
                  left: 45.w,
                  right: 45.w,
                  child: Text(
                    'كلمة المرور',
                    textAlign: TextAlign.right,
                    style: AppTextStyles.fieldLabel,
                  ),
                ),

                // PASSWORD FIELD
                Positioned(
                  top: 408.h,
                  left: 45.w,
                  right: 45.w,
                  child: AppTextField(
                    hintText: 'password',
                    obscureText: true,

                    suffixIcon: Padding(
                      padding: EdgeInsets.all(11.r),
                      child: Icon(
                        Icons.lock_outline,
                        size: 21.w,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                // FORGOT PASSWORD
                Positioned(
                  top: 467.h,
                  left: 45.w,
                  child: GestureDetector(
                    onTap: () {
                      //
                    },
                    child: Text(
                      'نسيت كلمة المرور؟',
                      style: AppTextStyles.linkText,
                    ),
                  ),
                ),

                // LOGIN BUTTON
                Positioned(
                  top: 520.h,
                  left: 45.w,
                  right: 45.w,
                  child: GestureDetector(
                    onTap: () {
                      //
                    },
                    child: Container(
                      height: 48.h,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.lightOrange, AppColors.orange],
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Center(
                        child: Text(
                          'تسجيل الدخول',
                          style: AppTextStyles.buttonText,
                        ),
                      ),
                    ),
                  ),
                ),

                // CREATE ACCOUNT
                Positioned(
                  top: 578.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'ليس لديك حساب؟ ',
                            style: AppTextStyles.secondaryText,
                          ),

                          TextSpan(
                            text: 'أنشئ حسابًا',
                            style: AppTextStyles.actionText,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
