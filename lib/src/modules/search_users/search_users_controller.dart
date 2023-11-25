import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sesoft_uni_mobile/src/modules/search_users/search_users_state.dart';

part 'search_users_controller.g.dart';

@Riverpod(keepAlive: true)
class SearchUsersController extends _$SearchUsersController {
  @override
  SearchUsersState build() => SearchUsersState();
}
