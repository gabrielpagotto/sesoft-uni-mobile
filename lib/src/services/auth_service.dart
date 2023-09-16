import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sesoft_uni_mobile/src/clients/sesoft_client.dart';
import 'package:sesoft_uni_mobile/src/exceptions/service_exception.dart';
import 'package:sesoft_uni_mobile/src/services/user_service.dart';

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
    @Default(AuthStatus.unknown) AuthStatus authStatus,
    @Default(FlutterSecureStorage()) FlutterSecureStorage storage,
  }) = _AuthServiceData;
}

@Riverpod(keepAlive: true)
class AuthService extends _$AuthService {
  @override
  AuthServiceState build() => const AuthServiceState();

  static const _tokenKey = 'AuthService.AccessToken';

  UserService get _userService => ref.read(userServiceProvider.notifier);

  Future<void> _realizeLoginWithAccessToken(String token) async {
    await state.storage.write(key: _tokenKey, value: token);
    state = state.copyWith(authStatus: AuthStatus.authenticated);
  }

  Future<String?> getToken() async {
    return state.storage.read(key: _tokenKey);
  }

  Future<void> verifyAuth() async {
    final token = await getToken();
    if (token == null) {
      state = state.copyWith(authStatus: AuthStatus.unauthenticated);
    } else {
      _realizeLoginWithAccessToken(token);
    }
  }

  Future<void> signin({required String email, required String password}) async {
    final client = ref.read(sesoftClientProvider);
    try {
      final data = {'email': email, 'password': password};
      final response = await client.post('/auth/signin', data: data);
      _realizeLoginWithAccessToken(response.data['token']);
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
      _realizeLoginWithAccessToken(response.data['token']);
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
    await state.storage.delete(key: _tokenKey);
    state = state.copyWith(authStatus: AuthStatus.unauthenticated);
  }
}
