import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sesoft_uni_mobile/src/models/user.dart';
import 'package:sesoft_uni_mobile/src/services/user_service.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_loader.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_text_form_field.dart';

part 'search_users_view.g.dart';

@riverpod
Future<User> _me(_MeRef ref) async {
  return ref.watch(userServiceProvider.notifier).me();
}

@riverpod
Future<List<User>> userFromSearch(UserFromSearchRef ref) async {
  final users = await ref.watch(userServiceProvider.notifier).list();
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
        const SesoftTextFormField(
          hintText: 'Buscar usuários',
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
          type: SesoftTextFormFieldType.secondary,
          prefixIcon: Icon(Icons.search),
        ),
        const Divider(height: 0),
        Consumer(builder: (context, ref, _) {
          final userFromSearchAsyncValue = ref.watch(userFromSearchProvider);
          return userFromSearchAsyncValue.when(
            data: (users) => Expanded(
              child: _Body(users: users),
            ),
            loading: () => const Expanded(child: SesoftLoader()),
            error: (_, __) {
              print(_);
              print(__);
              return Container();
            },
          );
        })
      ],
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({super.key, required this.users});

  final List<User> users;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: users
          .map((user) => ListTile(
                title: Text(user.profile?.displayName ?? ''),
              ))
          .toList(),
    );
  }
}
