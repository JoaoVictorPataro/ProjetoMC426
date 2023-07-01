import 'package:flutter_test/flutter_test.dart';
import 'package:safe_neighborhood/models/validator.dart';

void main() {
  group("Password test", () {
    test("Rule 1", () {
      String pass = "ab1!";
      expect(Validator.validatePass(pass), false);
    });
    test("Rule 2", () {
      String pass = "ABCDEF1*";
      expect(Validator.validatePass(pass), false);
    });
    test("Rule 3", () {
      String pass = "ABCdefg&";
      expect(Validator.validatePass(pass), false);
    });
    test("Rule 4", () {
      String pass = "ABCdefg1";
      expect(Validator.validatePass(pass), false);
    });
    test("Rule 5", () {
      String pass = "ABCde1@";
      expect(Validator.validatePass(pass), false);
    });
    test("Rule 6", () {
      String pass = "12345678";
      expect(Validator.validatePass(pass), false);
    });
    test("Rule 7", () {
      String pass = "abcdef1!";
      expect(Validator.validatePass(pass), false);
    });
    test("Rule 8", () {
      String pass = "abcDEF1!";
      expect(Validator.validatePass(pass), true);
    });
  });
}