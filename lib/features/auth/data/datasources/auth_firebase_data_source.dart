import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/forgot_password/forgot_password_request_body.dart';
import '../models/forgot_password/forgot_password_response.dart';
import '../models/login/login_request_body.dart';
import '../models/login/login_response.dart';
import '../models/register/register_request_body.dart';
import '../models/register/register_response.dart' as register_models;
import '../models/reset_password/reset_password_request_body.dart';
import '../models/reset_password/reset_password_response.dart';
import '../models/verify_otp/verify_otp_request_body.dart';
import '../models/verify_otp/verify_otp_response.dart';
import 'auth_remote_data_source.dart';

// ينفّذ المصادقة عبر Firebase ويحفظ بيانات الملف الشخصي في Firestore.
class AuthFirebaseDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthFirebaseDataSourceImpl({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  // مجموعة Firestore التي تحفظ بيانات المستخدم الإضافية تحت معرّفه.
  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  // يسجل الدخول بالبريد وكلمة المرور ثم يجلب رمز الهوية وبيانات الملف.
  @override
  Future<LoginResponse> login(LoginRequestBody body) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: body.email,
      password: body.password,
    );

    final user = credential.user;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'تعذر العثور على بيانات المستخدم بعد تسجيل الدخول',
      );
    }

    // رمز الهوية يثبت تسجيل دخول المستخدم ويُعاد إلى المستودع لحفظه.
    final idToken = await user.getIdToken() ?? '';

    final profile = await _fetchUserProfile(user);

    return LoginResponse(
      message: 'تم تسجيل الدخول بنجاح',
      token: idToken,
      user: profile,
    );
  }

  // ينشئ حساب Firebase ثم يحفظ الاسم والهاتف والدور في Firestore.
  @override
  Future<register_models.RegisterResponse> register(
    RegisterRequestBody body,
  ) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: body.email,
      password: body.password,
    );

    final user = credential.user;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'unknown',
        message: 'تعذر إنشاء الحساب',
      );
    }

    // حفظ الاسم في حساب Firebase بالإضافة إلى ملف Firestore.
    await user.updateDisplayName(body.fullName);

    // استخدام معرّف الحساب نفسه لربط بيانات الملف الشخصي بالمصادقة.
    await _usersCollection.doc(user.uid).set({
      'fullName': body.fullName,
      'email': body.email,
      'phone': body.phone,
      'role': body.role,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return register_models.RegisterResponse(
      message: 'تم إنشاء الحساب بنجاح',
      user: register_models.UserData(
        id: user.uid,
        fullName: body.fullName,
        email: body.email,
        role: body.role,
      ),
    );
  }

  // يرسل رابط الاستعادة؛ يعيّن المستخدم كلمة المرور من صفحة Firebase في المتصفح.
  @override
  Future<ForgotPasswordResponse> forgotPassword(
    ForgotPasswordRequestBody body,
  ) async {
    await _firebaseAuth.sendPasswordResetEmail(email: body.email);

    return ForgotPasswordResponse(
      message: 'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني',
    );
  }

  // غير مدعوم في هذا المصدر؛ استعادة كلمة المرور تستخدم رابط البريد.
  @override
  Future<VerifyOtpResponse> verifyOtp(VerifyOtpRequestBody body) async {
    throw UnimplementedError(
      'التحقق برمز OTP غير مدعوم بعد الانتقال إلى Firebase Auth؛ '
      'استخدم رابط إعادة تعيين كلمة المرور المرسل بالبريد بدلاً من ذلك.',
    );
  }

  // غير مدعوم داخل هذا المصدر؛ تغيير كلمة المرور يتم عبر رابط البريد.
  @override
  Future<ResetPasswordResponse> resetPassword(
    ResetPasswordRequestBody body,
  ) async {
    throw UnimplementedError(
      'تغيير كلمة المرور من داخل التطبيق غير مدعوم بعد الانتقال إلى '
      'Firebase Auth؛ يتم ذلك عبر رابط البريد الإلكتروني مباشرة.',
    );
  }

  // يُخرج المستخدم من Firebase.
  @override
  Future<void> logout() => _firebaseAuth.signOut();

  // بعد الدخول أو إنشاء الحساب يكون المستخدم مسجلًا في Firebase.
  // عند فتح التطبيق يستعيد Firebase المستخدم المحفوظ بعد لحظة، فننتظر أول
  // حالة له إن لم يكن جاهزًا بعد.
  @override
  Future<String?> currentIdToken() async {
    final user = _firebaseAuth.currentUser ??
        await _firebaseAuth.authStateChanges().first;
    return user?.getIdToken();
  }

  // يقرأ الاسم والدور من Firestore مع قيم بديلة عند غياب بيانات الملف.
  Future<UserData> _fetchUserProfile(User user) async {
    // قراءة بيانات الملف الإضافية؛ القيم البديلة أدناه تغطي غياب المستند.
    final doc = await _usersCollection.doc(user.uid).get();
    final data = doc.data();

    return UserData(
      id: user.uid,
      fullName: (data?['fullName'] as String?) ?? user.displayName ?? '',
      email: user.email ?? '',
      // فارغ إن لم يُحفظ دور في Firestore (مثل تاجر أنشأه الأدمن بدون مستند)،
      // فلا نمنعه من الدخول بناءً على قيمة مفترضة.
      role: (data?['role'] as String?) ?? '',
    );
  }
}
