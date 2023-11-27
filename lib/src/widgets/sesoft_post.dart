import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sesoft_uni_mobile/src/exceptions/service_exception.dart';
import 'package:sesoft_uni_mobile/src/helpers/extensions/build_context.dart';
import 'package:sesoft_uni_mobile/src/helpers/utils/share_util.dart';
import 'package:sesoft_uni_mobile/src/helpers/utils/snackbar.dart';
import 'package:sesoft_uni_mobile/src/models/post.dart';
import 'package:sesoft_uni_mobile/src/modules/post/post_view.dart';
import 'package:sesoft_uni_mobile/src/modules/profile/profile_view.dart';
import 'package:sesoft_uni_mobile/src/services/posts_service.dart';
import 'package:sesoft_uni_mobile/src/services/timeline_service.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_post_image.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_profile_icon.dart';

class SesoftPost extends ConsumerWidget {
  const SesoftPost({super.key, required this.post, this.disabledIconNavigation = false});

  final Post post;
  final bool disabledIconNavigation;

  Future<void> handleRate(WidgetRef ref) async {
    try {
      if (post.userLiked != null) {
        if (post.userLiked!) {
          await unlike(ref);
        } else {
          await like(ref);
        }
        return;
      }

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
      ref.read(timelineServiceProvider.notifier).setPostRate(post.id, true);
      ref.invalidate(uniquePostVisualizationProvider);
      ref.invalidate(getPostsProfileViewProvider);
      ref.invalidate(getLikedPostsProfileViewProvider);
    } on ServiceException catch (_) {
      // Do nothing
    }
  }

  Future<void> unlike(WidgetRef ref) async {
    final postsService = ref.read(postsServiceProvider.notifier);

    try {
      await postsService.unlike(post.id);
      ref.read(timelineServiceProvider.notifier).setPostRate(post.id, false);
      ref.invalidate(uniquePostVisualizationProvider);
      ref.invalidate(getPostsProfileViewProvider);
      ref.invalidate(getLikedPostsProfileViewProvider);
    } on ServiceException catch (_) {
      // Do nothing
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
        onTap: () => _toPost(context),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SesoftProfileIcon(key: ValueKey(post.user?.profile?.icon?.id), user: post.user!, callProfileOnClick: !disabledIconNavigation),
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
                              style: context.textTheme.titleSmall?.copyWith(color: context.theme.colorScheme.outline),
                            ),
                          ],
                        ),
                        Text(
                          post.content,
                          style: context.textTheme.bodyLarge?.copyWith(),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
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
              padding: const EdgeInsets.only(left: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => _toPost(context),
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
                          post.liked || (post.userLiked ?? false) ? Icons.favorite : Icons.favorite_border,
                          color: post.liked || (post.userLiked ?? false) ? Colors.red : null,
                        ),
                        iconSize: 15,
                        padding: EdgeInsets.zero,
                      ),
                      Text(post.likesCount.toString()),
                    ],
                  ),
                  IconButton(
                    onPressed: () => ShareUtil.sharePost(post),
                    icon: const Icon(Icons.ios_share),
                    iconSize: 15,
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
