import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_controller.freezed.dart';
part 'profile_controller.g.dart';

@freezed
class ProfileState with _$ProfileState {
  factory ProfileState({
    @Default(ProfileController._infoContainerMaxHeight) infoContainerHeight,
    required ScrollController scrollController,
  }) = _ProfileState;
}

@riverpod
class ProfileController extends _$ProfileController {
  @override
  ProfileState build() {
    final scrollController = ScrollController();
    scrollController.addListener(changeHeightOfInfoContainer);
    return ProfileState(scrollController: scrollController);
  }

  static const _infoContainerMaxHeight = 78.0;

  void changeHeightOfInfoContainer() {
    final offset = state.scrollController.offset - 100.0;
    if (offset < 0) {
      state = state.copyWith(infoContainerHeight: _infoContainerMaxHeight);
    } else if (offset / 1.5 < (_infoContainerMaxHeight)) {
      state = state.copyWith(infoContainerHeight: _infoContainerMaxHeight - (offset / 1.5));
    } else {
      state = state.copyWith(infoContainerHeight: .00);
    }
  }
}
