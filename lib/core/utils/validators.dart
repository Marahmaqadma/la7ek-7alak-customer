class Validators {
  const Validators._();

  static final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  static final RegExp _passwordRegex = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$',
  );

  static String? requiredField(String? value, {String fieldName = 'الحقل'}) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال $fieldName';
    }

    return null;
  }

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

  static String? phone(String? value) {
    final requiredError = requiredField(value, fieldName: 'رقم الهاتف');
    if (requiredError != null) {
      return requiredError;
    }

    final digitsOnly = value!.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length < 10) {
      return 'يجب أن يحتوي رقم الهاتف على 10 خانات';
    }

    return null;
  }

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

  static String? city(String? value) {
    return requiredField(value, fieldName: 'المدينة أو المنطقة');
  }

  static String? otpDigit(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '';
    }

    if (!RegExp(r'^\d$').hasMatch(value.trim())) {
      return '';
    }

    return null;
  }

  static bool isEmailValid(String value) => email(value) == null;

  static bool isPhoneValid(String value) => phone(value) == null;

  static bool isPasswordValid(String value) => _passwordRegex.hasMatch(value);
}
