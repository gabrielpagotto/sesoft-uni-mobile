import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sesoft_uni_mobile/src/exceptions/service_exception.dart';
import 'package:sesoft_uni_mobile/src/helpers/utils/snackbar.dart';
import 'package:sesoft_uni_mobile/src/services/auth_service.dart';

part 'signup_controller.freezed.dart';
part 'signup_controller.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class SignupControllerState with _$SignupControllerState {
  factory SignupControllerState({
    @Default(false) bool isSubmited,
    @Default(false) bool isSubmiting,
    required GlobalKey<FormState> formKey,
    required TextEditingController displayNameTextController,
    required TextEditingController usernameTextController,
    required TextEditingController emailTextController,
    required TextEditingController passwordTextController,
  }) = _SignupControllerState;
}

extension SignupControllerStateExtension on SignupControllerState {
  get autovalidateMode => isSubmited ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled;
}

@riverpod
class SignupController extends _$SignupController {
  @override
  SignupControllerState build() => SignupControllerState(
        formKey: GlobalKey<FormState>(),
        displayNameTextController: TextEditingController(),
        usernameTextController: TextEditingController(),
        emailTextController: TextEditingController(),
        passwordTextController: TextEditingController(),
      );

  Future<void> submit() async {
    final isFormValid = state.formKey.currentState!.validate();
    if (!isFormValid) {
      state = state.copyWith(isSubmited: true);
      return;
    }
    try {
      state = state.copyWith(isSubmiting: true);
      await ref.read(authServiceProvider.notifier).signup(
            displayName: state.displayNameTextController.text,
            username: state.usernameTextController.text,
            email: state.emailTextController.text,
            password: state.passwordTextController.text,
          );
    } on ServiceException catch (err) {
      SesoftSnackbar.error(err.message);
    } finally {
      state = state.copyWith(isSubmiting: false);
    }
  }
}
