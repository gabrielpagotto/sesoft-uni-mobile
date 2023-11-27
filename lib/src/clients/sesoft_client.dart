import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sesoft_uni_mobile/src/services/auth_service.dart';

part 'sesoft_client.g.dart';

@Riverpod(dependencies: [AuthService])
Dio sesoftClient<T>(SesoftClientRef ref) {
  final authStatus = ref.watch(authServiceProvider.select((value) => value.authStatus));
  final authService = ref.read(authServiceProvider.notifier);
  final baseOptions = BaseOptions(
    // baseUrl: 'https://sesoft-uni-backend-development.up.railway.app',
    baseUrl: 'http://10.11.0.215:4000',
    validateStatus: (status) => _validateStatus(status, authStatus),
  );
  final client = Dio(baseOptions);
  if (authStatus == AuthStatus.authenticated) {
    client.interceptors.add(_LogoutIfUnauthorized(authService));
    client.interceptors.add(_InsertBearerTokenInterceptor(authService));
  }
  return client;
}

bool _validateStatus(int? status, AuthStatus authStatus) {
  if (status == null) {
    return false;
  }
  if (status >= 400) {
    if (authStatus == AuthStatus.authenticated && status == 401) {
      return true;
    }
    return false;
  }
  return true;
}

class _InsertBearerTokenInterceptor extends Interceptor {
  final AuthService authService;

  _InsertBearerTokenInterceptor(this.authService);

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await authService.getToken();
    options.headers['Authorization'] = 'Bearer $token';
    super.onRequest(options, handler);
  }
}

class _LogoutIfUnauthorized extends Interceptor {
  final AuthService authService;

  _LogoutIfUnauthorized(this.authService);

  @override
  Future<void> onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.statusCode == 401) {
      authService.signout();
    }
    super.onResponse(response, handler);
  }
}
