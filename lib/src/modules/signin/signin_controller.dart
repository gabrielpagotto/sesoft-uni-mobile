import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sesoft_uni_mobile/src/exceptions/service_exception.dart';
import 'package:sesoft_uni_mobile/src/helpers/utils/snackbar.dart';
import 'package:sesoft_uni_mobile/src/services/auth_service.dart';

part 'signin_controller.freezed.dart';
part 'signin_controller.g.dart';

@freezed
class SigninControllerState with _$SigninControllerState {
  const factory SigninControllerState({
    required bool isSubmited,
    required bool isSubmiting,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailTextController,
    required TextEditingController passwordTextController,
  }) = _SigninControllerState;
}

extension SigninControllerStateExtension on SigninControllerState {
  get autovalidateMode => isSubmited ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled;
}

@riverpod
class SigninController extends _$SigninController {
  @override
  SigninControllerState build() => SigninControllerState(
        isSubmited: false,
        isSubmiting: false,
        formKey: GlobalKey<FormState>(),
        emailTextController: TextEditingController(),
        passwordTextController: TextEditingController(),
      );

  Future<void> submit() async {
    final isFormValid = state.formKey.currentState!.validate();
    if (!isFormValid) {
      state = state.copyWith(isSubmited: true);
      return;
    }
    final email = state.emailTextController.text;
    final password = state.passwordTextController.text;
    try {
      state = state.copyWith(isSubmiting: true);
      await ref.read(authServiceProvider.notifier).signin(email: email, password: password);
    } on ServiceException catch (err) {
      SesoftSnackbar.error(err.message);
    } finally {
      state = state.copyWith(isSubmiting: false);
    }
  }
}
