import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sesoft_uni_mobile/src/constants/fake_data.dart';
import 'package:sesoft_uni_mobile/src/models/post.dart';
import 'package:sesoft_uni_mobile/src/services/posts_service.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_one_post.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_scaffold.dart';
import 'package:skeletonizer/skeletonizer.dart';

part 'post_view.g.dart';

@riverpod
Future<Post> _post(_PostRef ref, {required String postId}) async {
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
    final postAsyncValue = ref.watch(_postProvider(postId: postId));

    return SesoftScaffold(
      titleText: 'Publicação',
      body: postAsyncValue.when(
        error: (_, __) => const Center(
          child: Text(
            'Não foi possível buscar a postagem. Tente novamente mais tarde!',
            textAlign: TextAlign.center,
          ),
        ),
        loading: () => Skeletonizer(child: SesoftOnePost(post: fakePostForOnePostView)),
        data: (post) => SesoftOnePost(post: post),
      ),
    );
  }
}
