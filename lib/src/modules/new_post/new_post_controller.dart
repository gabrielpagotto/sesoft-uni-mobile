import 'dart:io';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sesoft_uni_mobile/src/exceptions/service_exception.dart';
import 'package:sesoft_uni_mobile/src/helpers/utils/snackbar.dart';
import 'package:sesoft_uni_mobile/src/services/posts_service.dart';
import 'package:sesoft_uni_mobile/src/services/timeline_service.dart';
import 'package:sesoft_uni_mobile/src/settings/router.dart';

part 'new_post_controller.freezed.dart';
part 'new_post_controller.g.dart';

@freezed
class NewPostState with _$NewPostState {
  factory NewPostState({
    required TextEditingController contentController,
    @Default(false) bool canSubmit,
    @Default(false) bool isSubmiting,
    @Default(<XFile>[]) List<XFile> files,
  }) = _NewPostState;
}

@riverpod
class NewPostController extends _$NewPostController {
  @override
  NewPostState build() {
    final contentController = TextEditingController();
    contentController.addListener(_listenContentControllerChanges);
    return NewPostState(
      contentController: contentController,
    );
  }

  PostsService get postsService => ref.read(postsServiceProvider.notifier);

  void _listenContentControllerChanges() {
    if (state.contentController.text.isNotEmpty) {
      state = state.copyWith(canSubmit: true);
    } else {
      state = state.copyWith(canSubmit: false);
    }
  }

  List<File> getFiles() {
    return state.files.map((e) => File(e.path)).toList();
  }

  Future<void> submit() async {
    try {
      state = state.copyWith(isSubmiting: true);
      await postsService.create(
        state.contentController.text,
        getFiles(),
      );
      SesoftSnackbar.success('Postagem foi publicada com sucesso.');
      router.pop();
      ref.read(timelineServiceProvider.notifier).refresh();
    } on ServiceException catch (err) {
      SesoftSnackbar.error(err.message);
    } finally {
      state = state.copyWith(isSubmiting: false);
    }
  }

  Future<void> selectDeviceFiles() async {
    final permissionStatus = await Permission.photos.request();
    if (permissionStatus.isDenied) {
      return;
    }
    final picker = ImagePicker();
    final files = await picker.pickMultiImage();
    if (files.isEmpty) {
      return;
    }
    state = state.copyWith(files: files);
  }

  void removeFile(XFile file) async {
    final files = List<XFile>.from(state.files);
    files.removeWhere((element) => element.path == file.path);
    state = state.copyWith(files: files);
  }
}
