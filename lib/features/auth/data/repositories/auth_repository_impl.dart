import 'package:dartz/dartz.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_backend_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/city/city_model.dart';
import '../models/register/register_response.dart';
import '../models/login/login_request_body.dart';
import '../models/register/register_request_body.dart';
import '../models/login/login_response.dart';
import '../models/forgot_password/forgot_password_request_body.dart';
import '../models/forgot_password/forgot_password_response.dart';
import '../models/verify_otp/verify_otp_request_body.dart';
import '../models/verify_otp/verify_otp_response.dart';
import '../models/reset_password/reset_password_request_body.dart';
import '../models/reset_password/reset_password_response.dart';

// ينسّق طلبات المصادقة، ويحفظ رمز الدخول، ويحوّل الاستثناءات إلى نتائج فشل.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  final StorageService? storageService;

  // اختياري: عند توفيره يُربط حساب Firebase بالباك إند ويُحفظ رمز الباك إند.
  final AuthBackendDataSource? backendDataSource;

  AuthRepositoryImpl(
    this.remoteDataSource, {
    this.storageService,
    this.backendDataSource,
  });

  // ينفّذ الدخول ويحفظ الرمز إن توفّر التخزين، ويعيد الخطأ عند تعذر أي خطوة.
  @override
  Future<Either<ErrorHandler, LoginResponse>> login(
      LoginRequestBody loginRequestBody) async {
    try {
      final response = await remoteDataSource.login(loginRequestBody);

      // نوع الحساب الحقيقي (من Firebase) يجب أن يطابق ما اختاره المستخدم،
      // وإلا يدخل زبون كتاجر أو العكس. نخرجه فورًا ونوضح السبب.
      // الدور الفارغ يعني غير معروف، فنتركه يدخل.
      final chosenRole = loginRequestBody.role;
      final actualRole = response.user.role;
      if (chosenRole != null &&
          actualRole.isNotEmpty &&
          actualRole != chosenRole) {
        await remoteDataSource.logout();
        return Left(ErrorHandler.withMessage(chosenRole == 'merchant'
            ? 'هذا الحساب ليس حساب تاجر، اختر "زبون" لتسجيل الدخول'
            : 'هذا حساب تاجر، اختر "تاجر" لتسجيل الدخول'));
      }

      // الباك إند يقبل رمزه فقط: نرسل له رمز Firebase ونحفظ الرمز الذي يرجعه.
      final backend = backendDataSource;
      final token = backend == null
          ? response.token
          : await backend.createSession(firebaseIdToken: response.token);

      // حفظ الرمز اختياري عند توفير خدمة التخزين؛ تستخدم الاختبارات المستودع دونها.
      if (token.isNotEmpty) {
        await storageService?.saveToken(token);
      }
      // نحفظ نوع الحساب لنفتح الرئيسية الصحيحة تلقائيًا في المرة القادمة.
      final role = chosenRole ?? actualRole;
      if (role.isNotEmpty) await storageService?.saveUserRole(role);

      return Right(response);
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  // عند فتح التطبيق: إن بقي المستخدم مسجلًا (Firebase + رمز الخادم + نوع
  // الحساب محفوظين) يرجع نوع حسابه ليدخل مباشرة، وإلا null (شاشة الترحيب).
  // يجدد رمز الخادم برمز Firebase جديد حتى لا ينتهي؛ فشل التجديد (مثل عدم
  // وجود إنترنت) لا يمنع الدخول بالرمز المحفوظ.
  @override
  Future<String?> restoreSession() async {
    final storage = storageService;
    if (storage == null) return null;
    try {
      final token = await storage.getToken();
      final role = await storage.getUserRole();
      if (token == null || token.isEmpty || role == null || role.isEmpty) {
        return null;
      }

      final idToken = await remoteDataSource.currentIdToken();
      if (idToken == null || idToken.isEmpty) return null;

      final backend = backendDataSource;
      if (backend != null) {
        try {
          final fresh = await backend
              .createSession(firebaseIdToken: idToken)
              .timeout(const Duration(seconds: 6));
          await storage.saveToken(fresh);
        } catch (_) {}
      }
      return role;
    } catch (_) {
      return null;
    }
  }

  // ينشئ الحساب في Firebase، ثم يربطه بالباك إند مع الاسم والجوال والمدينة
  // حتى تُحفظ هناك، ويحفظ رمز الباك إند. كلمة المرور تبقى عند Firebase فقط.
  @override
  Future<Either<ErrorHandler, RegisterResponse>> register(
      RegisterRequestBody body) async {
    try {
      final response = await remoteDataSource.register(body);

      final backend = backendDataSource;
      if (backend != null) {
        final idToken = await remoteDataSource.currentIdToken();
        if (idToken != null && idToken.isNotEmpty) {
          final token = await backend.createSession(
            firebaseIdToken: idToken,
            name: body.fullName,
            phone: body.phone,
            address: body.address,
            role: body.role,
          );
          await storageService?.saveToken(token);
        }
      }

      return Right(response);
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  // يمرر طلب استعادة كلمة المرور إلى مصدر البيانات ويعيد النتيجة أو رسالة الفشل.
  @override
  Future<Either<ErrorHandler, ForgotPasswordResponse>> forgotPassword(
      ForgotPasswordRequestBody body) async {
    try {
      final response = await remoteDataSource.forgotPassword(body);
      return Right(response);
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  // يمرر طلب التحقق من الرمز إلى مصدر البيانات ويعيد النتيجة أو رسالة الفشل.
  @override
  Future<Either<ErrorHandler, VerifyOtpResponse>> verifyOtp(
      VerifyOtpRequestBody body) async {
    try {
      final response = await remoteDataSource.verifyOtp(body);
      return Right(response);
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  // يمرر طلب تعيين كلمة المرور إلى مصدر البيانات ويعيد النتيجة أو رسالة الفشل.
  @override
  Future<Either<ErrorHandler, ResetPasswordResponse>> resetPassword(
      ResetPasswordRequestBody body) async {
    try {
      final response = await remoteDataSource.resetPassword(body);
      return Right(response);
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  // يُخرج المستخدم من Firebase ويمسح رمز الخادم وبياناته المحفوظة على الجهاز.
  // المسح المحلي يتم حتى لو فشل Firebase، حتى لا يبقى الرمز صالحًا للاستخدام.
  @override
  Future<Either<ErrorHandler, Unit>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(unit);
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    } finally {
      await storageService?.clearSession();
    }
  }

  // بدون اتصال بالباك إند (مثل الاختبارات) لا توجد مدن.
  @override
  Future<Either<ErrorHandler, List<CityModel>>> getCities() async {
    final backend = backendDataSource;
    if (backend == null) return const Right([]);
    try {
      return Right(await backend.getCities());
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
}
