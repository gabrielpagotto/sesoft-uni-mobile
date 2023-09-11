import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sesoft_uni_mobile/src/modules/posts/posts_controller.dart';
import 'package:sesoft_uni_mobile/src/services/timeline_service.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_loader.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_post.dart';

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
      error: (error, trace) => const Text('Ocorreu um erro'),
      loading: () => const SesoftLoader(),
      data: (posts) => ListView.separated(
        key: postsState.pageStorageKey,
        itemCount: posts.length,
        itemBuilder: (context, index) => Consumer(builder: (context, ref, _) {
          return SesoftPost(post: ref.watch(postsControllerProvider.select((value) => posts[index])));
        }),
        separatorBuilder: (context, index) => const Divider(height: 0),
      ),
    );
  }
}
