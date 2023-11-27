import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sesoft_uni_mobile/src/helpers/extensions/build_context.dart';
import 'package:sesoft_uni_mobile/src/helpers/providers/current_user.dart';
import 'package:sesoft_uni_mobile/src/models/user.dart';
import 'package:sesoft_uni_mobile/src/modules/follows_and_following/follows_and_following_view.dart';
import 'package:sesoft_uni_mobile/src/modules/profile/profile_view.dart';
import 'package:sesoft_uni_mobile/src/modules/settings/settings_view.dart';
import 'package:sesoft_uni_mobile/src/services/auth_service.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_elevated_button.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_profile_icon.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeDrawerWidget extends ConsumerWidget {
  const HomeDrawerWidget({super.key});

  Future<void> _signout(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<bool?>(
      context: context,
      builder: (context) => AlertDialog(
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
      ),
    );
    if (result != null && result) {
      ref.read(authServiceProvider.notifier).signout();
    }
  }

  void _toProfile(BuildContext context) {
    context.pop();
    context.push(ProfileView.ROUTE);
  }

  void _toSettings(BuildContext context) {
    context.pop();
    context.push(SettingsView.ROUTE);
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
                onTap: () => _toProfile(context),
              ),
              ListTile(
                trailing: const Icon(Icons.settings),
                title: const Text('Configurações'),
                onTap: () => _toSettings(context),
              ),
              ListTile(
                trailing: const Icon(Icons.logout),
                title: const Text('Sair'),
                onTap: () => _signout(context, ref),
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
          currentUser?.profile?.displayName ?? 'unknown display',
          style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          currentUser?.username ?? 'unknownusername',
          style: context.textTheme.titleSmall?.copyWith(
            color: context.theme.colorScheme.outline,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: currentUser != null ? () => context.push(FollowsAndFollowingView.ROUTE, extra: (FollowsAndFollowingViewTab.following, currentUser!.id)) : null,
              child: _HomeDrawerHeaderFollowItem(count: currentUser?.followingsCount ?? 0, label: 'Seguindo'),
            ),
            const SizedBox(width: 20),
            GestureDetector(
              onTap: currentUser != null ? () => context.push(FollowsAndFollowingView.ROUTE, extra: (FollowsAndFollowingViewTab.followers, currentUser!.id)) : null,
              child: _HomeDrawerHeaderFollowItem(count: currentUser?.followersCount ?? 0, label: 'Seguidores'),
            ),
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
