import 'dart:io';

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

  Future<void> create(String content, [List<File> files = const []]) async {
    final client = ref.read(sesoftClientProvider);
    final multipartFiles = <MultipartFile>[];
    for (final file in files) {
      multipartFiles.add(await MultipartFile.fromFile(file.path));
    }
    final formData = FormData.fromMap({
      'content': content,
      'files': multipartFiles,
    });
    await client.post('/posts', data: formData);
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

  Future<Post> reply(String postId, String content) async {
    final client = ref.read(sesoftClientProvider);
    try {
      final response = await client.post("/posts/$postId/reply", data: {'content': content});
      return Post.fromJson(response.data);
    } on DioException catch (err) {
      throw ServiceException(err.message.toString());
    }
  }
}
