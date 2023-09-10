import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sesoft_uni_mobile/src/services/auth_service.dart';

part 'sesoft_client.g.dart';

@Riverpod(dependencies: [AuthService])
Dio sesoftClient<T>(SesoftClientRef ref) {
  final authStatus = ref.watch(authServiceProvider.select((value) => value.authStatus));
  final baseOptions = BaseOptions(
    baseUrl: 'https://sesoft-uni-backend-development.up.railway.app',
    validateStatus: (status) => _validateStatus(status, authStatus),
  );
  final client = Dio(baseOptions);
  if (authStatus == AuthStatus.authenticated) {
    client.interceptors.add(_InsertBearerTokenInterceptor());
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
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // TODO: implement onRequest
    super.onRequest(options, handler);
  }
}
