class AuthValidators {
  static String? username(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter Username";
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter Password";
    }
    return null;
  }
}
