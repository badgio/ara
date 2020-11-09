class AuthValidators {
  static String validateEmail(String email) {
    if (email.isEmpty) return 'Please enter your e-mail address';
    Pattern pattern = r'^[a-zA-Z0-9.\-]+@[a-zA-Z0-9\-]+\.[a-zA-Z]+';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(email))
      return 'Please enter a valid e-mail address';
    else
      return null;
  }

  static String validatePassword(String email) {
    if (email.isEmpty)
      return 'Please enter your password';
    else
      return null;
  }
}
