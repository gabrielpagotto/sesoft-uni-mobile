import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sesoft_uni_mobile/src/helpers/extensions/build_context.dart';
import 'package:sesoft_uni_mobile/src/services/auth_service.dart';
import 'package:sesoft_uni_mobile/src/services/timeline_service.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_elevated_button.dart';
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
            itemBuilder: (context, index) {
              final post = posts[index];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.person, size: 35),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              post.user!.profile!.displayName,
                              style: context.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "@${post.user!.username}",
                              style: context.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          posts[index].content,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.mode_comment),
                                  iconSize: 15,
                                  padding: EdgeInsets.zero,
                                ),
                                Text(post.likesCount.toString()),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.favorite),
                                  iconSize: 15,
                                  padding: EdgeInsets.zero,
                                ),
                                Text(post.likesCount.toString()),
                              ],
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.ios_share),
                              iconSize: 15,
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) => const Divider(),
          );
        },
        error: (err, trace) {
          return const Align(child: Text('Ocorreu um erro'));
        },
        loading: () => Align(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator.adaptive(),
              const SizedBox(height: 10),
              Text(
                'CARREGANDO...',
                style: context.textTheme.labelSmall,
              ),
            ],
          ),
        ),
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
                        color: context.theme.colorScheme.inversePrimary,
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
                                color: context.theme.colorScheme.inversePrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 2.5),
                            Text(
                              'Seguindo',
                              style: context.textTheme.titleSmall?.copyWith(
                                color: context.theme.colorScheme.inversePrimary,
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
                                color: context.theme.colorScheme.inversePrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 2.5),
                            Text(
                              'Seguidores',
                              style: context.textTheme.titleSmall?.copyWith(
                                color: context.theme.colorScheme.inversePrimary,
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
