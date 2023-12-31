import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sesoft_uni_mobile/src/modules/home/home_controller.dart';
import 'package:sesoft_uni_mobile/src/modules/home/home_drawer_widget.dart';
import 'package:sesoft_uni_mobile/src/modules/new_post/new_post_view.dart';
import 'package:sesoft_uni_mobile/src/modules/posts/posts_view.dart';
import 'package:sesoft_uni_mobile/src/modules/search_users/search_users_view.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_scaffold.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_text_form_field.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  // ignore: constant_identifier_names
  static const ROUTE = '/home';

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  HomeController get controller => ref.read(homeControllerProvider.notifier);

  @override
  Widget build(BuildContext context) {
    return SesoftScaffold(
      titleText: 'Sesoft Uni',
      body: ref.watch(homeControllerProvider.select((value) => value.currentTabIndex)) == 0 ? const PostsView() : const SearchUsersView(),
      drawer: const HomeDrawerWidget(),
      appBarBottom: ref.watch(homeControllerProvider.select((value) => value.currentTabIndex)) == 1
          ? PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Consumer(
                builder: (context, ref, _) {
                  return SesoftTextFormField(
                    hintText: 'Buscar usuários',
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.search,
                    type: SesoftTextFormFieldType.secondary,
                    prefixIcon: const Icon(Icons.search),
                    controller: ref.watch(homeControllerProvider.select((value) => value.searchFieldTextController)),
                  );
                },
              ),
            )
          : null,
      floatingActionButton: ref.watch(homeControllerProvider.select((value) => value.currentTabIndex == 0))
          ? FloatingActionButton(
              onPressed: () => context.push(NewPostView.ROUTE),
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: Consumer(builder: (context, ref, _) {
        return BottomNavigationBar(
          elevation: 4,
          enableFeedback: true,
          type: BottomNavigationBarType.fixed,
          onTap: controller.changeTabIndex,
          currentIndex: ref.watch(homeControllerProvider.select((value) => value.currentTabIndex)),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.house_rounded), label: 'Página inicial'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
          ],
        );
      }),
    );
  }
}
