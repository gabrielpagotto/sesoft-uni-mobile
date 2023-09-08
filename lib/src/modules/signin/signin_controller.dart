import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sesoft_uni_mobile/src/services/auth_service.dart';

part 'signin_controller.freezed.dart';
part 'signin_controller.g.dart';

@freezed
class SigninControllerState with _$SigninControllerState {
  const factory SigninControllerState({
    required bool isSubmiting,
    required String email,
    required String password,
  }) = _SigninControllerState;
}

@riverpod
class SigninController extends _$SigninController {
  @override
  SigninControllerState build() => const SigninControllerState(
        isSubmiting: false,
        email: "",
        password: "",
      );

  void changeEmail(String value) {
    state = state.copyWith(email: value);
  }

  void changePassword(String value) {
    state = state.copyWith(password: value);
  }

  Future<void> submit() async {
    state = state.copyWith(isSubmiting: true);
    try {
      await ref.read(authServiceProvider.notifier).signin(email: "gabriel.pagotto@cloud.com", password: "gabriel123");
    } finally {
      state = state.copyWith(isSubmiting: false);
    }
  }
}
