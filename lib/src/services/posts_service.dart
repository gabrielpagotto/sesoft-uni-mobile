import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sesoft_uni_mobile/src/clients/sesoft_client.dart';
import 'package:sesoft_uni_mobile/src/exceptions/service_exception.dart';

part 'posts_service.g.dart';

@riverpod
class PostsService extends _$PostsService {
  @override
  List build() => [];

  Future<void> create(String content) async {
    final client = ref.read(sesoftClientProvider);
    await client.post('/posts', data: {'content': content});
  }

  Future<void> like(String postId) async {
    final client = ref.read(sesoftClientProvider);
    try {
      await client.post("/posts/$postId/like");
    } on DioException catch (err) {
      throw ServiceException(err.message.toString());
    }
  }

  Future<void> unlike(String postId) async {
    final client = ref.read(sesoftClientProvider);
    try {
      print("/posts/$postId/unlike");
      await client.post("/posts/$postId/unlike");
    } on DioException catch (err) {
      throw ServiceException(err.message.toString());
    }
  }
}
