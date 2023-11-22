import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sesoft_uni_mobile/src/services/posts_service.dart';

part 'post_controller.freezed.dart';
part 'post_controller.g.dart';

@freezed
class PostState with _$PostState {
  factory PostState({@Default(0) postId}) = _PostState;
}

@Riverpod(keepAlive: true)
class PostController extends _$PostController {
  @override
  PostState build() => PostState();

  PostsService get postsService => ref.read(postsServiceProvider.notifier);
}
