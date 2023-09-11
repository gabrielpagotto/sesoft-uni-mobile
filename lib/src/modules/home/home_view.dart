import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sesoft_uni_mobile/src/helpers/extensions/build_context.dart';
import 'package:sesoft_uni_mobile/src/services/auth_service.dart';
import 'package:sesoft_uni_mobile/src/services/timeline_service.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_elevated_button.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_loader.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_post.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_scaffold.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  // ignore: constant_identifier_names
  static const ROUTE = '/home';

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  Future<void> signout() async {
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
  Widget build(BuildContext context) {
    final timeline = ref.watch(timelineServiceProvider);
    return SesoftScaffold(
      titleText: 'Sesoft Uni',
      body: timeline.when(
        data: (posts) {
          return ListView.separated(
            itemCount: posts.length,
            itemBuilder: (context, index) => SesoftPost(post: posts[index]),
            separatorBuilder: (context, index) => const Divider(
              height: 0,
            ),
          );
        },
        error: (err, trace) {
          return const Align(child: Text('Ocorreu um erro'));
        },
        loading: () => const SesoftLoader(),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.person,
                      size: 48,
                    ),
                    Text('Gabriel Pagotto', style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    Text(
                      'gabrielnpagotto',
                      style: context.textTheme.titleSmall?.copyWith(
                        color: context.theme.colorScheme.outline,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              '177',
                              style: context.textTheme.titleMedium?.copyWith(
                                color: context.theme.colorScheme.outline,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 2.5),
                            Text(
                              'Seguindo',
                              style: context.textTheme.titleSmall?.copyWith(
                                color: context.theme.colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Row(
                          children: [
                            Text(
                              '34',
                              style: context.textTheme.titleMedium?.copyWith(
                                color: context.theme.colorScheme.outline,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 2.5),
                            Text(
                              'Seguidores',
                              style: context.textTheme.titleSmall?.copyWith(
                                color: context.theme.colorScheme.outline,
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
                child: ListView(
              children: [
                const ListTile(
                  trailing: Icon(Icons.person),
                  title: Text('Perfil'),
                ),
                ListTile(
                  trailing: const Icon(Icons.logout),
                  title: const Text('Sair'),
                  onTap: signout,
                )
              ],
            )),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 4,
        enableFeedback: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.house_rounded), label: 'Página inicial'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
          BottomNavigationBarItem(icon: Icon(Icons.notification_add), label: 'Notificações'),
        ],
      ),
    );
  }
}
