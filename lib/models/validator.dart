class Validator {
  /*
    Passwords must contain:
      - Minimun 8 characters,
      - Minimum 1 Upper case,
      - Minimum 1 lowercase,
      - Minimum 1 Numeric Number,
      - Minimum 1 Special Character,
  */
  static bool validatePass (String pass) {
    String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(pass);
  }
}