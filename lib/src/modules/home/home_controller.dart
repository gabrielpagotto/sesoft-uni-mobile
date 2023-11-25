import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_controller.freezed.dart';
part 'home_controller.g.dart';

@freezed
class HomeState with _$HomeState {
  factory HomeState({
    @Default(0) int currentTabIndex,
    @Default("") String searchFieldText,
    required TextEditingController searchFieldTextController,
  }) = _HomeControllerState;
}

@Riverpod(keepAlive: true)
class HomeController extends _$HomeController {
  @override
  HomeState build() {
    final searchFieldTextController = TextEditingController();
    searchFieldTextController.addListener(() {
      EasyDebounce.cancel(_DEBOUNCE_SEARCH_TEXT_TAG);
      EasyDebounce.debounce(
        _DEBOUNCE_SEARCH_TEXT_TAG,
        const Duration(seconds: 1),
        () => state = state.copyWith(searchFieldText: searchFieldTextController.text),
      );
    });
    return HomeState(searchFieldTextController: searchFieldTextController);
  }

  // ignore: constant_identifier_names
  static const _DEBOUNCE_SEARCH_TEXT_TAG = '';

  void changeTabIndex(int index) {
    state = state.copyWith(currentTabIndex: index);
  }
}
