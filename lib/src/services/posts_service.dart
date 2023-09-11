import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sesoft_uni_mobile/src/clients/sesoft_client.dart';

part 'posts_service.g.dart';

@riverpod
class PostsService extends _$PostsService {
  @override
  List build() => [];

  Future<void> create(String content) async {
    final client = ref.read(sesoftClientProvider);
    try {
      await client.post('/posts', data: {'content': content});
    } on DioException {}
  }
}
