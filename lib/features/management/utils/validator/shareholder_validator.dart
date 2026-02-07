class ShareholderValidator {
  static String? name(String? value) {
    if (value == null || value.isEmpty) return 'Please enter shareholder name';
    return null;
  }

  static String? percentage(String? value) {
    if (value == null || value.isEmpty) return 'Please enter percentage';
    final n = double.tryParse(value);
    if (n == null || n < 0 || n > 100) return 'Enter a valid percentage (0-100)';
    return null;
  }
}
