import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sesoft_uni_mobile/src/constants/fake_data.dart';
import 'package:sesoft_uni_mobile/src/models/post.dart';
import 'package:sesoft_uni_mobile/src/modules/post/post_controller.dart';
import 'package:sesoft_uni_mobile/src/services/posts_service.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_post.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_post_image.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_profile_icon.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_scaffold.dart';
import 'package:skeletonizer/skeletonizer.dart';

part 'post_view.g.dart';

@riverpod
Future<Post> uniquePostVisualization(UniquePostVisualizationRef ref, {required String postId}) async {
  final postsService = ref.read(postsServiceProvider.notifier);
  return await postsService.getPost(postId);
}

class PostView extends ConsumerWidget {
  final String postId;

  const PostView({Key? key, required this.postId}) : super(key: key);

  // ignore: constant_identifier_names
  static const ROUTE = '/post';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postAsyncValue = ref.watch(uniquePostVisualizationProvider(postId: postId));

    return SesoftScaffold(
      titleText: 'Publicação',
      body: postAsyncValue.when(
        error: (_, __) => const Center(
          child: Text(
            'Não foi possível buscar a postagem. Tente novamente mais tarde!',
            textAlign: TextAlign.center,
          ),
        ),
        loading: () => const Skeletonizer(child: _Body(post: fakePostForOnePostView)),
        data: (post) => _Body(post: post),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      if (post.user == null) const SizedBox.shrink(),
                      if (post.user != null)
                        Row(
                          children: [
                            SesoftProfileIcon(
                              user: post.user!,
                              size: 42,
                            ),
                            const SizedBox(width: 16.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.user!.profile?.displayName ?? '',
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                                Text(
                                  post.user!.username,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      const SizedBox(height: 16.0),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          post.content,
                          textAlign: TextAlign.start,
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => {},
                            icon: Icon(
                              post.userLiked == true ? Icons.favorite : Icons.favorite_border,
                              color: post.userLiked == true ? Colors.red : null,
                            ),
                            iconSize: 15,
                            padding: EdgeInsets.zero,
                          ),
                          Text(post.likesCount.toString()),
                        ],
                      ),
                    ],
                  ),
                ),
                if (post.files.isNotEmpty)
                  Container(
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(children: post.files.map((e) => SesoftPostImage(storage: e)).toList()),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Consumer(builder: (context, ref, _) {
                    return TextField(
                      controller: ref.watch(postControllerProvider.select((value) => value.postCommentTextController)),
                      focusNode: ref.watch(postControllerProvider.select((value) => value.postCommentTextFocusNode)),
                      decoration: InputDecoration(
                        hintText: 'Adicione um comentário',
                        suffixIcon: Consumer(builder: (context, ref, _) {
                          return IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: ref.watch(postControllerProvider.select((value) => value.replying || !value.commentIsValid))
                                ? null
                                : () => ref.read(postControllerProvider.notifier).reply(post.id),
                          );
                        }),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          Column(
            children: post.replies.map((e) => SesoftPost(post: e)).toList(),
          ),
        ],
      ),
    );
  }
}
