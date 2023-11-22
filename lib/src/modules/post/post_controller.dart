import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sesoft_uni_mobile/src/exceptions/service_exception.dart';
import 'package:sesoft_uni_mobile/src/helpers/utils/snackbar.dart';
import 'package:sesoft_uni_mobile/src/modules/post/post_view.dart';
import 'package:sesoft_uni_mobile/src/services/posts_service.dart';

part 'post_controller.freezed.dart';
part 'post_controller.g.dart';

@freezed
class PostState with _$PostState {
  factory PostState({
    @Default(false) bool replying,
    @Default(false) bool commentIsValid,
    required TextEditingController postCommentTextController,
  }) = _PostState;
}

@Riverpod(keepAlive: true)
class PostController extends _$PostController {
  @override
  PostState build() {
    final postCommentTextController = TextEditingController();
    postCommentTextController.addListener(() {
      if (state.commentIsValid && postCommentTextController.text.isEmpty) {
        state = state.copyWith(commentIsValid: false);
      } else if (!state.commentIsValid && postCommentTextController.text.isNotEmpty) {
        state = state.copyWith(commentIsValid: true);
      }
    });
    return PostState(postCommentTextController: postCommentTextController);
  }

  PostsService get postsService => ref.read(postsServiceProvider.notifier);

  Future<void> reply(String postId) async {
    state = state.copyWith(replying: true);
    final text = state.postCommentTextController.text;
    try {
      await postsService.reply(postId, text);
      state.postCommentTextController.text = "";
      SesoftSnackbar.success('Seu comentário foi enviado.');
      ref.invalidate(uniquePostVisualizationProvider);
    } on ServiceException catch (_) {
      SesoftSnackbar.error('Não foi possível postar o comentário.');
    } finally {
      state = state.copyWith(replying: false);
    }
  }
}
