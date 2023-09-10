import 'package:sesoft_uni_mobile/src/helpers/utils/validator_util.dart';

class SignupValidators {
  static String? validateDisplayName(String? displayName) {
    if (displayName?.isEmpty ?? true) {
      return 'Informe o nome completo';
    }
    return null;
  }

  static String? validateUsername(String? username) {
    if (username?.isEmpty ?? true) {
      return 'Informe um nome de usuário';
    }
    if (!RegExp(r'^[a-zA-Z0-9_]').hasMatch(username!)) {
      return 'O nome de usuário deve começar com um caractere alfanumérico ou sublinhado';
    }
    if (!RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(username)) {
      return 'O nome de usuário só pode conter caracteres alfanuméricos, sublinhados e hifens';
    }
    if (username.length > 15) {
      return "O nome de usuário deve possuir no máximo 15 caracteres";
    }
    return null;
  }

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
      return 'A senha deve possuir ao menos 6 caracteres';
    }
    return null;
  }

  static String? validatePasswordConfirmation(String password, String? passwordConfirmation) {
    if (passwordConfirmation?.isEmpty ?? true) {
      return 'Informe a confirmação de senha';
    }
    if (password != passwordConfirmation) {
      return 'Senha e confirmação de senha devem ser iguais';
    }
    return null;
  }
}
