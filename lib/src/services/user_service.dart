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

  Future<User> find(String id) async {
    final client = ref.watch(sesoftClientProvider);
    final response = await client.get('/users/find/$id');
    return User.fromJson(response.data);
  }

  Future<List<User>> list({String? search}) async {
    final client = ref.watch(sesoftClientProvider);
    final qp = <String, String>{};
    if (search?.isNotEmpty ?? false) {
      qp['search'] = search!;
    }
    final response = await client.get('/users', queryParameters: qp);
    return response.data['result'].map<User>((e) => User.fromJson(e)).toList();
  }
}
