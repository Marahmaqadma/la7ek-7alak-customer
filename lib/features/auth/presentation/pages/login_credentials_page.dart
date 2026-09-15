import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../data/models/login/login_request_body.dart';
import '../cubit/login/login_cubit.dart';

import '../widgets/login_type_card.dart' show LoginType;

// تستقبل نوع الحساب وتعرض نموذج البريد وكلمة المرور.
class LoginCredentialsPage extends StatefulWidget {

  final LoginType loginType;

  const LoginCredentialsPage({super.key, required this.loginType});

  @override
  State<LoginCredentialsPage> createState() => _LoginCredentialsPageState();
}

// يدير حقول الدخول وإظهار كلمة المرور وخيار تذكرني.
class _LoginCredentialsPageState extends State<LoginCredentialsPage> {

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isPasswordObscured = true;

  bool _rememberMe = false;

  // يحرر متحكمات الحقول والموارد المستخدمة عند إغلاق الواجهة.
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // نوع الحساب يحدد نص الزر والصفحة التي تُفتح بعد نجاح الدخول.
    final bool isMerchant = widget.loginType == LoginType.merchant;
    final sx = MediaQuery.sizeOf(context).width / 375;
    final sy = MediaQuery.sizeOf(context).height / 812;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Directionality(

        textDirection: TextDirection.rtl,
        child: Stack(
          children: [

            Positioned(
              top: -70 * sy,
              left: -24 * sx,
              child: _decorativeCircle(132 * sx, 127 * sy),
            ),
            Positioned(
              bottom: -12 * sy,
              left: 325 * sx,
              child: _decorativeCircle(68 * sx, 68 * sy),
            ),

            Positioned(
                top: 77 * sy,
                left: 325 * sx,
                child: _decorativeCircle(68 * sx, 68 * sy)),
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16 * sx, vertical: 0),
                      child: BlocConsumer<LoginCubit, LoginState>(

                        // يتابع نتيجة الطلب لإظهار رسالة للمستخدم أو الانتقال إلى الشاشة التالية.
                        listener: (context, state) async {
                          if (state is LoginSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(state.loginResponse.message)),
                            );
                            // حفظ اسم المستهلك قبل فتح حسابه، بينما ينتقل التاجر إلى واجهته الخاصة.
                            if (!isMerchant) {

                              await const StorageService().saveUserFullName(
                                  state.loginResponse.user.fullName);
                              if (!context.mounted) return;
                              Navigator.pushReplacementNamed(
                                  context, AppRouter.home);
                            } else {

                              Navigator.pushReplacementNamed(
                                  context, AppRouter.sellerHome);
                            }
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
                                SizedBox(
                                    height: (82 * sy -
                                            MediaQuery.paddingOf(context).top)
                                        .clamp(0.0, double.infinity)),

                                Text('تسجيل الدخول',
                                    style: AppTextStyles.loginTitle
                                        .copyWith(fontSize: 20 * sx)),
                                SizedBox(height: 10 * sy),
                                Text(
                                  'قم بتسجيل دخولك للمتابعة',
                                  style: AppTextStyles.loginSubtitle.copyWith(
                                      fontSize: 14 * sx, height: 19 / 14),
                                ),
                                SizedBox(height: 30 * sy),

                                Text('البريد الإلكتروني',
                                    style: AppTextStyles.loginFieldLabel
                                        .copyWith(
                                            fontSize: 14 * sx,
                                            fontWeight: FontWeight.w400,
                                            height: 17 / 14)),
                                SizedBox(height: 5 * sy),
                                CustomTextField(
                                  // يُعرض البريد من اليسار لليمين حتى داخل الواجهة العربية.
                                  controller: emailController,
                                  hintText: 'ayaayaaya@gmail',
                                  keyboardType: TextInputType.emailAddress,

                                  textDirection: TextDirection.ltr,
                                  textAlign: TextAlign.left,
                                  validator: Validators.email,
                                  height: 48 * sy / ScreenUtil().scaleHeight,
                                  borderRadius: 15,

                                  fillColor: AppColors.loginFieldFill,
                                  enabledBorderColor: Colors.transparent,
                                  focusedBorderColor: AppColors.introNavy,
                                  hintStyle: AppTextStyles.loginFieldHintStyle
                                      .copyWith(
                                          fontSize: 14 * sx, height: 17 / 14),
                                  textStyle: AppTextStyles.loginFieldHintStyle
                                      .copyWith(
                                          fontSize: 14 * sx,
                                          height: 17 / 14,
                                          color: AppColors.introNavy),
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 9 * sx, vertical: 15.5 * sy),
                                ),
                                SizedBox(height: 27 * sy),

                                Text('كلمة المرور',
                                    style: AppTextStyles.loginFieldLabel
                                        .copyWith(
                                            fontSize: 14 * sx,
                                            fontWeight: FontWeight.w400,
                                            height: 17 / 14)),
                                SizedBox(height: 5 * sy),
                                CustomTextField(
                                  controller: passwordController,
                                  hintText: '••••••••••',
                                  // إخفاء كلمة المرور أو عرضها وفق اختيار المستخدم.
                                  obscureText: _isPasswordObscured,
                                  validator: Validators.password,
                                  height: 48 * sy / ScreenUtil().scaleHeight,
                                  borderRadius: 15,
                                  fillColor: AppColors.loginFieldFill,
                                  enabledBorderColor: Colors.transparent,
                                  focusedBorderColor: AppColors.introNavy,
                                  hintStyle: AppTextStyles.loginFieldHintStyle
                                      .copyWith(
                                          fontSize: 14 * sx, height: 17 / 14),
                                  textStyle: AppTextStyles.loginFieldHintStyle
                                      .copyWith(
                                          fontSize: 14 * sx,
                                          height: 17 / 14,
                                          color: AppColors.introNavy),
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 9 * sx, vertical: 15.5 * sy),

                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordObscured =
                                            !_isPasswordObscured;
                                      });
                                    },
                                    icon: Icon(
                                      _isPasswordObscured
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      size: 24 * sx,
                                      color: AppColors.loginFieldHint,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10 * sy),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(
                                            () => _rememberMe = !_rememberMe);
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: 14 * sx,
                                            height: 17 * sy,
                                            child: Checkbox(
                                              value: _rememberMe,
                                              onChanged: (v) {
                                                setState(() =>
                                                    _rememberMe = v ?? false);
                                              },
                                              activeColor: AppColors.introNavy,
                                              side: const BorderSide(
                                                  color: Color(0xFFD9D9D9),
                                                  width: 1),
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                            ),
                                          ),
                                          SizedBox(width: 6.w),
                                          Text('تذكرني',
                                              style: AppTextStyles
                                                  .rememberMeText
                                                  .copyWith(
                                                      fontSize: 14 * sx,
                                                      height: 17 / 14,
                                                      color: const Color(
                                                          0xFFD9D9D9))),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(context,
                                            AppRouter.sendVerificationCode);
                                      },
                                      child: Text('هل نسيت كلمة المرور ؟',
                                          style: AppTextStyles.loginFieldLabel
                                              .copyWith(
                                                  fontSize: 14 * sx,
                                                  fontWeight: FontWeight.w400,
                                                  height: 17 / 14)),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30 * sy),

                                Center(
                                  child: state is LoginLoading
                                      ? const CircularProgressIndicator()
                                      : CustomButton(
                                          text: isMerchant
                                              ? 'تسجيل الدخول كتاجر'
                                              : 'تسجيل الدخول',
                                          // لا يرسل الطلب إلا بعد اجتياز الحقول لقواعد التحقق.
                                          onTap: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              context.read<LoginCubit>().login(
                                                    LoginRequestBody(
                                                      email: emailController
                                                          .text
                                                          .trim(),
                                                      password:
                                                          passwordController
                                                              .text
                                                              .trim(),
                                                      role: isMerchant
                                                          ? 'merchant'
                                                          : 'consumer',
                                                    ),
                                                  );
                                            }
                                          },
                                          backgroundColor: AppColors.introNavy,
                                          textStyle: AppTextStyles
                                              .introButtonText
                                              .copyWith(fontSize: 16 * sx),
                                          width: double.infinity,
                                          height: 48 * sy,
                                          borderRadius: 15 * sx,
                                        ),
                                ),
                                SizedBox(height: 10.h),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                        bottom: (48 * sy - MediaQuery.paddingOf(context).bottom)
                            .clamp(13 * sy, double.infinity)),
                    child: Center(
                      child: GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, AppRouter.register),
                        child: SizedBox(
                          height: 24 * sy,
                          child: Text.rich(TextSpan(
                            style: TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 14 * sx,
                                height: 24 / 14,
                                color: AppColors.introNavy),
                            children: const [
                              TextSpan(text: 'هل لديك حساب ؟ '),
                              TextSpan(
                                  text: 'قم بالإنشاء',
                                  style: TextStyle(color: Color(0xFFFF8A00))),
                            ],
                          )),
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
    );
  }

  // ينشئ دائرة خلفية بالحجم المطلوب.
  Widget _decorativeCircle(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.decorativePeach,
      ),
    );
  }
}
