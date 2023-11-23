import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sesoft_uni_mobile/src/exceptions/service_exception.dart';
import 'package:sesoft_uni_mobile/src/helpers/extensions/build_context.dart';
import 'package:sesoft_uni_mobile/src/helpers/utils/snackbar.dart';
import 'package:sesoft_uni_mobile/src/models/post.dart';
import 'package:sesoft_uni_mobile/src/modules/post/post_view.dart';
import 'package:sesoft_uni_mobile/src/modules/posts/posts_controller.dart';
import 'package:sesoft_uni_mobile/src/services/posts_service.dart';
import 'package:sesoft_uni_mobile/src/services/timeline_service.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_profile_icon.dart';

class SesoftPost extends ConsumerWidget {
  const SesoftPost({super.key, required this.post});

  final Post post;

  Future<void> handleRate(WidgetRef ref) async {
    try {
      if (post.liked) {
        await unlike(ref);
        return;
      }

      await like(ref);
    } on ServiceException catch (err) {
      showSnackbarError(err.message);
    }
  }

  Future<void> like(WidgetRef ref) async {
    final postsService = ref.read(postsServiceProvider.notifier);

    try {
      await postsService.like(post.id);
      ref.read(postsControllerProvider.notifier);
      ref.read(timelineServiceProvider.notifier).setPostRate(post.id, true);

      showSnackbarSuccess('Publicação curtida!');
    } on ServiceException catch (err) {
      showSnackbarError(err.message);
    }
  }

  Future<void> unlike(WidgetRef ref) async {
    final postsService = ref.read(postsServiceProvider.notifier);

    try {
      await postsService.unlike(post.id);
      ref.read(postsControllerProvider.notifier);
      ref.read(timelineServiceProvider.notifier).setPostRate(post.id, false);

      showSnackbarSuccess('Publicação descurtida!');
    } on ServiceException catch (err) {
      showSnackbarError(err.message);
    }
  }

  void showSnackbarError(String message) {
    SesoftSnackbar.error(message);
  }

  void showSnackbarSuccess(String message) {
    SesoftSnackbar.success(message);
  }

  void _toPost(BuildContext context) {
    context.push(PostView.ROUTE, extra: post.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Ink(
      child: InkWell(
        onTap: () {
          _toPost(context);
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 10, right: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SesoftProfileIcon(user: post.user!),
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
                          style: context.textTheme.titleSmall?.copyWith(
                              color: context.theme.colorScheme.outline),
                        ),
                      ],
                    ),
                    Text(
                      post.content,
                      style: context.textTheme.bodyLarge?.copyWith(),
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
                            Text(post.repliesCount.toString()),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => handleRate(ref),
                              icon: Icon(
                                post.liked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: post.liked ? Colors.red : null,
                              ),
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
          ),
        ),
      ),
    );
  }
}
