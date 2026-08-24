extension StringExtensions on String {
  bool get isValidEmail => RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(this);
}
