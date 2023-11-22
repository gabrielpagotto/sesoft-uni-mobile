import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sesoft_uni_mobile/src/clients/sesoft_client.dart';
import 'package:sesoft_uni_mobile/src/exceptions/service_exception.dart';
import 'package:sesoft_uni_mobile/src/models/post.dart';

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
      await client.post("/posts/$postId/unlike");
    } on DioException catch (err) {
      throw ServiceException(err.message.toString());
    }
  }

  Future<Post> getPost(String postId) async {
    final client = ref.read(sesoftClientProvider);
    final response = await client.get("/posts/$postId");
    return Post.fromJson(response.data);
  }
}
