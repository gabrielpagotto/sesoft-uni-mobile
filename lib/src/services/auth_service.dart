import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_service.freezed.dart';
part 'auth_service.g.dart';

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
}

@freezed
class AuthServiceState with _$AuthServiceState {
  const factory AuthServiceState({
    required AuthStatus authStatus,
  }) = _AuthServiceData;
}

@Riverpod(keepAlive: true)
class AuthService extends _$AuthService {
  @override
  AuthServiceState build() => const AuthServiceState(authStatus: AuthStatus.unknown);

  Future<void> signin({required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(authStatus: AuthStatus.authenticated);
  }

  Future<void> signup() async {}

  Future<void> signout() async {
    state = state.copyWith(authStatus: AuthStatus.unauthenticated);
  }
}
