import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sesoft_uni_mobile/src/helpers/extensions/build_context.dart';
import 'package:sesoft_uni_mobile/src/helpers/providers/current_user.dart';
import 'package:sesoft_uni_mobile/src/models/profile.dart';
import 'package:sesoft_uni_mobile/src/models/user.dart';
import 'package:sesoft_uni_mobile/src/services/auth_service.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_elevated_button.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_profile_icon.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeDrawerWidget extends ConsumerWidget {
  const HomeDrawerWidget({super.key});

  Future<void> signout(BuildContext context, WidgetRef ref) async {
    context.pop();
    final dialog = AlertDialog(
      title: const Text('Deslogar-se?'),
      content: const Text('Ao se deslogar do aplicativo será necessário se autenticar novamente para acessar.'),
      actions: [
        TextButton(
          child: const Text('Voltar'),
          onPressed: () => context.pop(false),
        ),
        SesoftElevatedButton(
          child: const Text('Continuar'),
          onPressed: () => context.pop(true),
        ),
      ],
    );
    final result = await showDialog<bool?>(
      context: context,
      builder: (context) => dialog,
    );
    if (result != null && result) {
      ref.read(authServiceProvider.notifier).signout();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: SizedBox(
              width: double.infinity,
              child: Consumer(builder: (context, ref, _) {
                final currentUserAsyncValue = ref.watch(currentUserProvider);
                return currentUserAsyncValue.when(
                  data: (currentUser) => _HomeDrawerHeader(currentUser),
                  error: ((error, stackTrace) => Container()),
                  loading: () => const Skeletonizer(
                    child: _HomeDrawerHeader(null),
                  ),
                );
              }),
            ),
          ),
          Expanded(
              child: ListView(
            children: [
              ListTile(
                trailing: const Icon(Icons.person),
                title: const Text('Perfil'),
                onTap: () {
                  context.pop();
                  context.push(
                    '/profile',
                    extra: const User(
                      id: 'id',
                      username: 'gabrielnpagotto',
                      email: 'gabriel.pagotto@icloud.com',
                      profile: Profile(id: 'id', displayName: 'Gabriel Pagotto'),
                      followersCount: 0,
                      followingsCount: 0,
                    ),
                  );
                },
              ),
              ListTile(
                trailing: const Icon(Icons.logout),
                title: const Text('Sair'),
                onTap: () => signout(context, ref),
              )
            ],
          )),
        ],
      ),
    );
  }
}

class _HomeDrawerHeader extends StatelessWidget {
  const _HomeDrawerHeader(this.currentUser);

  final User? currentUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SesoftProfileIcon(
          size: 45,
          user: currentUser ?? const User(id: "", username: "", email: ""),
        ),
        const SizedBox(height: 5),
        Text(
          currentUser?.profile?.displayName ?? 'Gabriel Pagotto',
          style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          currentUser?.username ?? 'gabrielpagotto',
          style: context.textTheme.titleSmall?.copyWith(
            color: context.theme.colorScheme.outline,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _HomeDrawerHeaderFollowItem(count: currentUser?.followingsCount ?? 0, label: 'Seguindo'),
            const SizedBox(width: 20),
            _HomeDrawerHeaderFollowItem(count: currentUser?.followersCount ?? 0, label: 'Seguidores'),
          ],
        )
      ],
    );
  }
}

class _HomeDrawerHeaderFollowItem extends StatelessWidget {
  const _HomeDrawerHeaderFollowItem({required this.count, required this.label});

  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          count.toString(),
          style: context.textTheme.titleMedium?.copyWith(
            color: context.theme.colorScheme.outline,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 2.5),
        Text(
          label,
          style: context.textTheme.titleSmall?.copyWith(
            color: context.theme.colorScheme.outline,
          ),
        ),
      ],
    );
  }
}
