import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_controller.freezed.dart';
part 'home_controller.g.dart';

@freezed
class HomeState with _$HomeState {
  factory HomeState({
    @Default(0) int currentTabIndex,
  }) = _HomeControllerState;
}

@riverpod
class HomeController extends _$HomeController {
  @override
  HomeState build() => HomeState();

  void changeTabIndex(int index) {
    state = state.copyWith(currentTabIndex: index);
  }
}
