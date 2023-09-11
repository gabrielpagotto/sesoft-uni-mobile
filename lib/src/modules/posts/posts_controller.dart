import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sesoft_uni_mobile/src/services/timeline_service.dart';

part 'posts_controller.freezed.dart';
part 'posts_controller.g.dart';

@freezed
class PostsState with _$PostsState {
  factory PostsState({
    @Default(0) int currentPage,
    @Default(PageStorageKey(0)) PageStorageKey pageStorageKey,
  }) = _PostsState;
}

@Riverpod(keepAlive: true)
class PostsController extends _$PostsController {
  @override
  PostsState build() => PostsState();

  TimelineService get timelineService => ref.read(timelineServiceProvider.notifier);
}
