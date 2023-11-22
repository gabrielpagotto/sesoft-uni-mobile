import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_one_post.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_scaffold.dart';

class PostView extends ConsumerWidget {
  final String postId;

  const PostView({Key? key, required this.postId}) : super(key: key);

  // ignore: constant_identifier_names
  static const ROUTE = '/post';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SesoftScaffold(
      body: SesoftOnePost(
        postId: postId,
      ),
      titleText: 'Publicação',
    );
  }
}
