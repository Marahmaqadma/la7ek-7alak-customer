import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/validators.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/services/storage_service.dart';
import '../../data/models/register/register_request_body.dart';
import '../cubit/cities/cities_cubit.dart';
import 'location_picker_page.dart';
import '../cubit/register/register_cubit.dart';

import 'package:la7ek_7alak/features/auth/presentation/widgets/register_widgets/register_header_widget.dart';
import 'package:la7ek_7alak/features/auth/presentation/widgets/register_widgets/register_background_widget.dart';
import 'package:la7ek_7alak/features/auth/presentation/widgets/register_widgets/register_form_widget.dart';

// شاشة إنشاء حساب جديد مع التحقق من المدخلات قبل الإرسال.
// التسجيل للزبائن فقط؛ حسابات التجار ينشئها الأدمن.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

// يدير حقول التسجيل وتطابق كلمتي المرور والمدينة المختارة.
class _RegisterPageState extends State<RegisterPage> {
  // مفتاح النموذج لفحص جميع الحقول معًا قبل الإرسال.
  final _formKey = GlobalKey<FormState>();

  // متحكمات تقرأ النصوص المدخلة وتُحرر عند إغلاق الصفحة.
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _selectedCity;
  bool _phoneValid = false;
  bool _emailValid = false;
  bool _passwordValid = false;
  bool _confirmPasswordValid = false;
  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  // يراقب تغيّر الحقول لتحديث علامات الصحة وتطابق كلمة المرور مباشرة.
  @override
  void initState() {
    super.initState();

    // تحديث علامة صحة البريد أثناء الكتابة.
    _emailController.addListener(() {
      final isValid = Validators.isEmailValid(_emailController.text);
      if (_emailValid != isValid) setState(() => _emailValid = isValid);
    });

    // تحديث علامة صحة الهاتف أثناء الكتابة.
    _phoneController.addListener(() {
      final isValid = Validators.isPhoneValid(_phoneController.text);
      if (_phoneValid != isValid) setState(() => _phoneValid = isValid);
    });

    // تغيير كلمة المرور يستلزم إعادة فحص قوتها وتطابق التأكيد معها.
    _passwordController.addListener(() {
      final passwordValid =
          Validators.isPasswordValid(_passwordController.text);
      final confirmValid = _confirmPasswordController.text.isNotEmpty &&
          _confirmPasswordController.text == _passwordController.text;

      if (_passwordValid != passwordValid ||
          _confirmPasswordValid != confirmValid) {
        setState(() {
          _passwordValid = passwordValid;
          _confirmPasswordValid = confirmValid;
        });
      }
    });

    // فحص التطابق مجددًا عند تعديل حقل التأكيد.
    _confirmPasswordController.addListener(() {
      final confirmValid = _confirmPasswordController.text.isNotEmpty &&
          _confirmPasswordController.text == _passwordController.text;
      if (_confirmPasswordValid != confirmValid) {
        setState(() => _confirmPasswordValid = confirmValid);
      }
    });
  }

  // يحرر متحكمات الحقول والموارد المستخدمة عند إغلاق الواجهة.
  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // يفتح الخريطة، ثم يختار أقرب مدينة من قائمة الخادم للنقطة المؤكدة.
  // يرجع اسم المدينة ليتحقق منه الحقل، أو null إن لم يكتمل الاختيار.
  Future<String?> _pickCity(CitiesState citiesState) async {
    final messenger = ScaffoldMessenger.of(context);
    void warn(String message) => messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(message, textAlign: TextAlign.right),
      ));

    // بدون قائمة المدن لا نستطيع تحويل النقطة لمدينة.
    if (citiesState.cities.isEmpty) {
      if (citiesState.status != CitiesStatus.loading) {
        context.read<CitiesCubit>().load();
      }
      warn(citiesState.status == CitiesStatus.error
          ? (citiesState.error ?? 'تعذر تحميل المدن')
          : 'جاري تحميل المدن، حاول بعد لحظات');
      return null;
    }

    // نبدأ من المدينة المختارة سابقًا إن وُجدت.
    final previous =
        citiesState.cities.where((c) => c.area == _selectedCity).firstOrNull;
    final previousLat = previous?.latitude;
    final previousLng = previous?.longitude;
    final picked = await Navigator.pushNamed<PickedLocation>(
      context,
      AppRouter.locationPicker,
      arguments: previousLat == null || previousLng == null
          ? null
          : (latitude: previousLat, longitude: previousLng),
    );
    if (picked == null || !mounted) return null;

    final city = citiesState.nearestCity(picked.latitude, picked.longitude);
    if (city == null) {
      warn('تعذر تحديد المدينة، حاول مرة أخرى');
      return null;
    }
    setState(() => _selectedCity = city.area);
    return city.area;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      // يتابع نتيجة الطلب لإظهار رسالة للمستخدم أو الانتقال إلى الشاشة التالية.
      listener: (context, state) async {
        if (state is RegisterSuccess) {
          // بعد نجاح التسجيل نحفظ المدينة محليًا لاستخدامها في صفحة الحساب.
          await const StorageService().saveSelectedCity(_selectedCity!);
          if (!context.mounted) return;
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
      builder: (context, state) => Scaffold(
        backgroundColor: AppColors.adminBackground,
        body: Stack(
          children: [
            const RegisterBackgroundWidget(),
            SafeArea(
              child: Directionality(
                textDirection: TextDirection.rtl,
                // إتاحة تمرير النموذج على الشاشات القصيرة وعند ظهور لوحة المفاتيح.
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
                        BlocBuilder<CitiesCubit, CitiesState>(
                          builder: (context, citiesState) => RegisterFormWidget(
                            onPickCity: () => _pickCity(citiesState),
                            isLoading: state is RegisterLoading,
                            formKey: _formKey,
                            fullNameController: _fullNameController,
                            emailController: _emailController,
                            phoneController: _phoneController,
                            passwordController: _passwordController,
                            confirmPasswordController:
                                _confirmPasswordController,
                            selectedCity: _selectedCity,
                            emailValid: _emailValid,
                            phoneValid: _phoneValid,
                            passwordValid: _passwordValid,
                            confirmPasswordValid: _confirmPasswordValid,
                            isPasswordObscured: _isPasswordObscured,
                            isConfirmPasswordObscured:
                                _isConfirmPasswordObscured,
                            onEyeTapPassword: () => setState(() =>
                                _isPasswordObscured = !_isPasswordObscured),
                            onEyeTapConfirmPassword: () => setState(() =>
                                _isConfirmPasswordObscured =
                                    !_isConfirmPasswordObscured),
                            // يفحص النموذج قبل إرسال بيانات الحساب إلى مدير حالة التسجيل.
                            onSubmit: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<RegisterCubit>().register(
                                      RegisterRequestBody(
                                        fullName:
                                            _fullNameController.text.trim(),
                                        email: _emailController.text.trim(),
                                        phone: _phoneController.text.trim(),
                                        password:
                                            _passwordController.text.trim(),
                                        role: 'consumer',
                                        address: _selectedCity,
                                      ),
                                    );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
