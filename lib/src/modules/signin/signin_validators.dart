import 'package:sesoft_uni_mobile/src/helpers/utils/validator_util.dart';

class SigninValidators {
  static String? validateEmail(String? email) {
    if (email?.isEmpty ?? true) {
      return 'Informe um email';
    }
    if (!ValidatorUtil.isEmailValid(email!)) {
      return 'O email informado não é válido';
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password?.isEmpty ?? true) {
      return 'Informe uma senha';
    }
    if (password!.length < 6) {
      return 'Senha deve possuir ao menos 6 caracteres';
    }
    return null;
  }
}
