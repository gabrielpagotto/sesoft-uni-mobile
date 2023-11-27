import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sesoft_uni_mobile/src/helpers/extensions/build_context.dart';
import 'package:sesoft_uni_mobile/src/models/user.dart';
import 'package:sesoft_uni_mobile/src/modules/home/home_controller.dart';
import 'package:sesoft_uni_mobile/src/modules/search_users/search_users_controller.dart';
import 'package:sesoft_uni_mobile/src/services/user_service.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_loader.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_user.dart';

part 'search_users_view.g.dart';

@Riverpod(keepAlive: true)
Future<User> _me(_MeRef ref) async {
  return ref.read(userServiceProvider.notifier).me();
}

@Riverpod(keepAlive: true)
Future<List<User>> userFromSearch(UserFromSearchRef ref) async {
  final search = ref.watch(homeControllerProvider.select((value) => value.searchFieldText));
  final users = await ref.read(userServiceProvider.notifier).list(search: search);
  final me = await ref.watch(_meProvider.future);
  users.removeWhere((element) => element.id == me.id);
  return users;
}

class SearchUsersView extends StatelessWidget {
  const SearchUsersView({super.key});

  // ignore: constant_identifier_names
  static const ROUTE = '/search-users';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer(builder: (context, ref, _) {
          final userFromSearchAsyncValue = ref.watch(userFromSearchProvider);
          return userFromSearchAsyncValue.when(
            data: (users) => Expanded(
              child: _Body(users: users),
            ),
            loading: () => const Expanded(child: SesoftLoader()),
            error: (_, __) {
              return Container();
            },
          );
        })
      ],
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.users});

  final List<User> users;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (users.isEmpty) {
      final searchText = ref.watch(homeControllerProvider.select((value) => value.searchFieldText));
      return Align(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Não foi encontrado nenhum usuário com "$searchText".',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.theme.hintColor,
              fontSize: 15,
            ),
          ),
        ),
      );
    }
    return ListView(
      key: ref.watch(searchUsersControllerProvider.select((value) => value.pageStorageKey)),
      children: users.map((user) => SesoftUser(user: user)).toList(),
    );
  }
}
