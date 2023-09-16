import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sesoft_uni_mobile/src/clients/sesoft_client.dart';
import 'package:sesoft_uni_mobile/src/models/user.dart';

part 'user_service.freezed.dart';
part 'user_service.g.dart';

@freezed
class UserServiceState with _$UserServiceState {
  factory UserServiceState() = _UserServiceState;
}

@Riverpod(dependencies: [sesoftClient])
class UserService extends _$UserService {
  @override
  UserServiceState build() => UserServiceState();

  Future<User> me() async {
    final client = ref.watch(sesoftClientProvider);
    final response = await client.get('/users/me');
    return User.fromJson(response.data);
  }
}