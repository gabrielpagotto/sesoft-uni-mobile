import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sesoft_uni_mobile/src/models/post.dart';
import 'package:sesoft_uni_mobile/src/models/profile.dart';
import 'package:sesoft_uni_mobile/src/models/user.dart';
import 'package:sesoft_uni_mobile/src/services/posts_service.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_one_post.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_scaffold.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PostView extends ConsumerWidget {
  final String postId;

  const PostView({Key? key, required this.postId}) : super(key: key);

  // ignore: constant_identifier_names
  static const ROUTE = '/post';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SesoftScaffold(
      body: FutureBuilder<Post>(
        future: handleFindPost(ref),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Skeletonizer(
              child: SesoftOnePost(
                post: const Post(
                  id: "",
                  content: "",
                  likesCount: 0,
                  repliesCount: 0,
                  user: User(
                    id: "",
                    username: "leonardooliveira",
                    email: "",
                    profile: Profile(id: "", displayName: "Leonardo Oliveira"),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return SesoftOnePost(post: snapshot.data!);
          }
        },
      ),
      titleText: 'Publicação',
    );
  }

  Future<Post> handleFindPost(WidgetRef ref) async {
    final postsService = ref.read(postsServiceProvider.notifier);
    return await postsService.getPost(postId);
  }
}
