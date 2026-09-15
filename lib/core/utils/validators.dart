// قواعد التحقق من الحقول؛ تعيد رسالة عند الخطأ وnull عند صحة القيمة.
class Validators {
  const Validators._();

  // نمط فحص صيغة البريد؛ لا يتحقق من وجود العنوان فعليًا.
  static final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  // قاعدة القوة: طول لا يقل عن ثمانية، مع حرف لاتيني ورقم ورمز.
  static final RegExp _passwordRegex = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$',
  );

  // يرفض القيمة الفارغة أو التي تحتوي على مسافات فقط.
  static String? requiredField(String? value, {String fieldName = 'الحقل'}) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال $fieldName';
    }

    return null;
  }

  // يشترط اسمًا غير فارغ يتكون من ثلاثة أحرف على الأقل.
  static String? fullName(String? value) {
    final requiredError = requiredField(value, fieldName: 'الاسم الكامل');
    if (requiredError != null) {
      return requiredError;
    }

    if (value!.trim().length < 3) {
      return 'يجب أن يحتوي الاسم على 3 أحرف على الأقل';
    }

    return null;
  }

  // يتحقق من وجود البريد وصيغته قبل قبول الحقل.
  static String? email(String? value) {
    final requiredError = requiredField(value, fieldName: 'البريد الإلكتروني');
    if (requiredError != null) {
      return requiredError;
    }

    if (!_emailRegex.hasMatch(value!.trim())) {
      return 'صيغة البريد الإلكتروني غير صالحة';
    }

    return null;
  }

  // يتجاهل الرموز عند العد ويشترط عشرة أرقام على الأقل.
  static String? phone(String? value) {
    final requiredError = requiredField(value, fieldName: 'رقم الهاتف');
    if (requiredError != null) {
      return requiredError;
    }

    // نحسب الأرقام فقط للسماح بكتابة الرقم مع مسافات أو فواصل.
    final digitsOnly = value!.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length < 10) {
      return 'يجب أن يحتوي رقم الهاتف على 10 خانات';
    }

    return null;
  }

  // يرفض كلمة المرور الفارغة أو التي لا تحقق قواعد القوة.
  static String? password(String? value) {
    final requiredError = requiredField(value, fieldName: 'كلمة المرور');
    if (requiredError != null) {
      return requiredError;
    }

    if (!isPasswordValid(value!)) {
      return 'يجب أن تحتوي كلمة المرور على 8 خانات (حروف , أرقام , رموز).';
    }

    return null;
  }

  // يتأكد أن التأكيد غير فارغ ويطابق كلمة المرور.
  static String? confirmPassword(String? value, String password) {
    final requiredError = requiredField(value, fieldName: 'تأكيد كلمة المرور');
    if (requiredError != null) {
      return requiredError;
    }

    if (value != password) {
      return 'يجب تطابق كلمتي المرور';
    }

    return null;
  }

  // يشترط اختيار المدينة أو المنطقة قبل إرسال النموذج.
  static String? city(String? value) {
    return requiredField(value, fieldName: 'المدينة أو المنطقة');
  }

  // يقبل رقمًا واحدًا فقط في كل خانة من رمز التحقق.
  static String? otpDigit(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '';
    }

    if (!RegExp(r'^\d$').hasMatch(value.trim())) {
      return '';
    }

    return null;
  }

  // يحوّل نتيجة فحص البريد إلى قيمة منطقية لعلامة الصحة.
  static bool isEmailValid(String value) => email(value) == null;

  // يحوّل نتيجة فحص الهاتف إلى قيمة منطقية لعلامة الصحة.
  static bool isPhoneValid(String value) => phone(value) == null;

  // يشترط ثمانية محارف على الأقل تتضمن حرفًا لاتينيًا ورقمًا ورمزًا.
  static bool isPasswordValid(String value) => _passwordRegex.hasMatch(value);
}
