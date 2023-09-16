import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sesoft_uni_mobile/src/models/user.dart';
import 'package:sesoft_uni_mobile/src/services/auth_service.dart';
import 'package:sesoft_uni_mobile/src/services/user_service.dart';

part 'current_user.g.dart';

@riverpod
class CurrentUser extends _$CurrentUser {
  @override
  Future<User> build() async {
    final authService = ref.read(authServiceProvider);
    if ([AuthStatus.unknown, AuthStatus.unauthenticated].contains(authService.authStatus)) {
      throw Exception('This provider only on $AuthService with ${AuthStatus.authenticated} status');
    }
    return await ref.read(userServiceProvider.notifier).me();
  }
}
