import 'package:dio/dio.dart';

class SesoftClient {
  final _client = Dio(BaseOptions(
    baseUrl: 'https://sesoft-uni-backend-development.up.railway.app',
  ));
}
