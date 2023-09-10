import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sesoft_uni_mobile/src/clients/sesoft_client.dart';
import 'package:sesoft_uni_mobile/src/exceptions/service_exception.dart';

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
    final client = ref.read(sesoftClientProvider);
    final data = {'email': email, 'password': password};
    try {
      await client.post('/auth/signin', data: data);
      // state = state.copyWith(authStatus: AuthStatus.authenticated);
    } on DioException catch (err) {
      if (err.response!.data['message'] == 'Username or password is invalid.') {
        throw ServiceException('Usuário ou senha inválidos');
      }
      rethrow;
    }
  }

  Future<void> signup() async {}

  Future<void> signout() async {
    state = state.copyWith(authStatus: AuthStatus.unauthenticated);
  }
}
