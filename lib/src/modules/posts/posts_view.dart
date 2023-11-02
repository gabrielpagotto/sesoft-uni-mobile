import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sesoft_uni_mobile/src/models/post.dart';
import 'package:sesoft_uni_mobile/src/models/profile.dart';
import 'package:sesoft_uni_mobile/src/models/user.dart';
import 'package:sesoft_uni_mobile/src/modules/home/home_controller.dart';
import 'package:sesoft_uni_mobile/src/modules/posts/posts_controller.dart';
import 'package:sesoft_uni_mobile/src/services/timeline_service.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_post.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PostsView extends ConsumerStatefulWidget {
  const PostsView({super.key});

  @override
  ConsumerState<PostsView> createState() => _PostsViewState();
}

class _PostsViewState extends ConsumerState<PostsView> {
  @override
  Widget build(BuildContext context) {
    final postsState = ref.watch(postsControllerProvider);
    final timelineService = ref.watch(timelineServiceProvider);
    return timelineService.when(
      error: (error, trace) {
        if (kDebugMode) {
          print(error);
        }
        return const Text('Ocorreu um erro');
      },
      loading: () => Skeletonizer(
        child: ListView.separated(
          key: postsState.pageStorageKey,
          itemCount: 15,
          itemBuilder: (context, index) => Consumer(
            builder: (context, ref, _) {
              return const SesoftPost(
                post: Post(
                  id: "",
                  content: "Este é um exemplo de um post muito foda que será somente para mostrar um loader na tela",
                  likesCount: 0,
                  repliesCount: 0,
                  user: User(
                    id: "",
                    username: "gabrielpagotto",
                    email: "",
                    profile: Profile(id: "", displayName: "Gabriel Pagotto"),
                  ),
                ),
              );
            },
          ),
          separatorBuilder: (context, index) => const Divider(height: 0),
        ),
      ),
      data: (posts) => ListView.separated(
        key: postsState.pageStorageKey,
        itemCount: posts.length,
        controller: ref.watch(homeControllerProvider.select((value) => value.scrollController)),
        itemBuilder: (context, index) => Consumer(builder: (context, ref, _) {
          return SesoftPost(post: ref.watch(postsControllerProvider.select((value) => posts[index])));
        }),
        separatorBuilder: (context, index) => const Divider(height: 0),
      ),
    );
  }
}
