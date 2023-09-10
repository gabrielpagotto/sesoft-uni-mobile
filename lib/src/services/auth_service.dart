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
    try {
      final data = {'email': email, 'password': password};
      await client.post('/auth/signin', data: data);
      // state = state.copyWith(authStatus: AuthStatus.authenticated);
    } on DioException catch (err) {
      if (err.response?.statusCode == 401) {
        if (err.response!.data['message'] == 'Username or password is invalid.') {
          throw ServiceException('Usuário ou senha inválidos');
        }
      }
      rethrow;
    }
  }

  Future<void> signup({
    required String displayName,
    required String username,
    required String email,
    required String password,
  }) async {
    final client = ref.read(sesoftClientProvider);
    try {
      final data = {
        'displayName': displayName,
        'username': username,
        'email': email,
        'password': password,
      };
      final response = await client.post('/auth/signup', data: data);
      print(response.data);
    } on DioException catch (err) {
      if (err.response?.statusCode == 400) {
        if (err.response?.data['message'] == 'A user already uses this username') {
          throw ServiceException('Este nome de usuário não está disponível');
        }
        if (err.response?.data['message'] == 'A user already uses this email') {
          throw ServiceException('Este email já está sendo utilizado por outro usuário');
        }
      }
      rethrow;
    }
  }

  Future<void> signout() async {
    state = state.copyWith(authStatus: AuthStatus.unauthenticated);
  }
}
