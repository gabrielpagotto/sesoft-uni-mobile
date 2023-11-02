import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_controller.freezed.dart';
part 'home_controller.g.dart';

@freezed
class HomeState with _$HomeState {
  factory HomeState({
    @Default(0) int currentTabIndex,
    required ScrollController scrollController,
  }) = _HomeControllerState;
}

@Riverpod(keepAlive: true)
class HomeController extends _$HomeController {
  @override
  HomeState build() => HomeState(scrollController: ScrollController());

  void changeTabIndex(int index) {
    state = state.copyWith(currentTabIndex: index);
    if (index == 0 && state.scrollController.offset != .0) {
      state.scrollController.animateTo(
        .0,
        duration: const Duration(milliseconds: 600),
        curve: Curves.ease,
      );
    }
  }
}
