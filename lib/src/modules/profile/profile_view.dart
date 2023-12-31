import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sesoft_uni_mobile/src/constants/fake_data.dart';
import 'package:sesoft_uni_mobile/src/helpers/extensions/build_context.dart';
import 'package:sesoft_uni_mobile/src/helpers/extensions/stateful_value_notifier_observer.dart';
import 'package:sesoft_uni_mobile/src/helpers/providers/current_user.dart';
import 'package:sesoft_uni_mobile/src/models/post.dart';
import 'package:sesoft_uni_mobile/src/models/user.dart';
import 'package:sesoft_uni_mobile/src/modules/edit_user/edit_profile_view.dart';
import 'package:sesoft_uni_mobile/src/modules/follows_and_following/follows_and_following_view.dart';
import 'package:sesoft_uni_mobile/src/modules/search_users/search_users_view.dart';
import 'package:sesoft_uni_mobile/src/services/auth_service.dart';
import 'package:sesoft_uni_mobile/src/services/timeline_service.dart';
import 'package:sesoft_uni_mobile/src/services/user_service.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_post.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_profile_icon.dart';
import 'package:skeletonizer/skeletonizer.dart';

part 'profile_view.g.dart';

@riverpod
Future<User> getUserProfileView(GetUserProfileViewRef ref, String? userId) async {
  if (userId == null) {
    return ref.read(currentUserProvider.future);
  } else {
    return ref.read(userServiceProvider.notifier).find(userId);
  }
}

@riverpod
Future<List<Post>> getPostsProfileView(GetPostsProfileViewRef ref, String userId) async {
  final userService = ref.read(userServiceProvider.notifier);
  return userService.userPosts(userId);
}

@riverpod
Future<List<Post>> getLikedPostsProfileView(GetLikedPostsProfileViewRef ref, String userId) async {
  final userService = ref.read(userServiceProvider.notifier);
  return userService.userPostsLiked(userId);
}

class ProfileView extends ConsumerStatefulWidget {
  final String? userId;

  const ProfileView({super.key, required this.userId});

  // ignore: constant_identifier_names
  static const ROUTE = '/profile';

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> with SingleTickerProviderStateMixin, StatefulValueNotifierObserver {
  final scrollController = ScrollController();
  var infoContainerHeight = ValueNotifier(_infoContainerMaxHeight);
  var tabIndex = 0;

  late final tabController = TabController(length: 2, vsync: this);

  @override
  void initState() {
    tabController.addListener(changeTabIndexListener);
    scrollController.addListener(changeHeightOfInfoContainer);
    super.initState();
  }

  void changeTabIndexListener() {
    setState(() {
      tabIndex = tabController.index;
    });
  }

  static const _infoContainerMaxHeight = 78.0;

  @override
  List<ValueNotifier> get notifiers => [infoContainerHeight];

  void changeHeightOfInfoContainer() {
    final offset = scrollController.offset - 100.0;
    if (offset < 0) {
      infoContainerHeight.value = _infoContainerMaxHeight;
    } else if (offset / 1.5 < (_infoContainerMaxHeight)) {
      infoContainerHeight.value = _infoContainerMaxHeight - (offset / 1.5);
    } else {
      infoContainerHeight.value = .00;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(getUserProfileViewProvider(widget.userId));

    final String? userProfileId = userAsyncValue.when(
      data: (data) => data.id,
      error: (error, stack) {
        return null;
      },
      loading: () => null,
    );

    final bool isSelf = ref.watch(authServiceProvider.select((value) => value.currentUser))?.id == widget.userId || widget.userId == null;

    return Scaffold(
      floatingActionButton: isSelf
          ? FloatingActionButton(
              onPressed: () => context.push(EditProfileView.ROUTE),
              child: const Icon(Icons.edit),
            )
          : null,
      body: Consumer(builder: (context, ref, child) {
        return CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverAppBar(
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TabBar(
                      controller: tabController,
                      tabs: const [
                        Tab(text: 'Postagens'),
                        Tab(text: 'Curtidas'),
                      ],
                    ),
                    const Divider(height: 0),
                  ],
                ),
              ),
              forceElevated: true,
              expandedHeight: 325,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [StretchMode.fadeTitle],
                centerTitle: false,
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: userAsyncValue.when(
                    data: (user) => _ProfileHeaderInfos(user, infoContainerHeight: infoContainerHeight.value, isSelf: isSelf),
                    error: (err, stack) => const Text("Ocorreu um erro ao buscar"),
                    loading: () => Skeletonizer(child: _ProfileHeaderInfos(null, infoContainerHeight: infoContainerHeight.value, isSelf: isSelf)),
                  ),
                ),
                collapseMode: CollapseMode.parallax,
              ),
            ),
            SliverToBoxAdapter(
              child: tabIndex == 0
                  ? IntrinsicHeight(
                      child: Consumer(builder: (context, ref, child) {
                        final postsAsyncValue = ref.watch(getPostsProfileViewProvider(userProfileId ?? ''));

                        return postsAsyncValue.when(
                          data: (posts) {
                            return UserPostsList(posts: posts, userId: widget.userId);
                          },
                          loading: () => Skeletonizer(
                            child: UserPostsList(posts: fakePostsList, userId: widget.userId),
                          ),
                          error: (err, stack) => const Text("Ocorreu um erro ao buscar"),
                        );
                      }),
                    )
                  : IntrinsicHeight(
                      child: Consumer(builder: (context, ref, child) {
                        final likedPostsAsyncValue = ref.watch(getLikedPostsProfileViewProvider(userProfileId ?? ''));

                        return likedPostsAsyncValue.when(
                          data: (likedPosts) {
                            return UserPostsList(posts: likedPosts, userId: widget.userId);
                          },
                          loading: () => Skeletonizer(
                            child: UserPostsList(posts: fakePostsList, userId: widget.userId),
                          ),
                          error: (err, stack) => const Text("Ocorreu um erro ao buscar"),
                        );
                      }),
                    ),
            ),
          ],
        );
      }),
    );
  }
}

class UserPostsList extends ConsumerWidget {
  final List<Post> posts;
  final String? userId;

  const UserPostsList({Key? key, required this.posts, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 120),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: posts
            .map(
              (post) => Column(
                children: [
                  SesoftPost(
                      post: post, disabledIconNavigation: ref.watch(authServiceProvider.select((value) => value.currentUser?.id == post.user?.id || post.user?.id == userId))),
                  const Divider(height: 0),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

class _ProfileHeaderInfos extends StatelessWidget {
  const _ProfileHeaderInfos(this.user, {required this.infoContainerHeight, required this.isSelf});

  final User? user;
  final double infoContainerHeight;
  final bool isSelf;

  Future<void> _follow(WidgetRef ref) async {
    try {
      await ref.read(userServiceProvider.notifier).follow(user!.id);
      ref.invalidate(getUserProfileViewProvider);
      ref.invalidate(userFromSearchProvider);
      ref.invalidate(followingProvider);
      ref.invalidate(followersProvider);
      ref.invalidate(getLikedPostsProfileViewProvider);
      ref.invalidate(getUserProfileViewProvider);
      ref.invalidate(timelineServiceProvider);
    } catch (_) {}
  }

  Future<void> _unfollow(WidgetRef ref) async {
    try {
      await ref.read(userServiceProvider.notifier).unfollow(user!.id);
      ref.invalidate(getUserProfileViewProvider);
      ref.invalidate(userFromSearchProvider);
      ref.invalidate(followingProvider);
      ref.invalidate(followersProvider);
      ref.invalidate(getLikedPostsProfileViewProvider);
      ref.invalidate(getUserProfileViewProvider);
      ref.invalidate(timelineServiceProvider);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.profile?.displayName ?? 'unknown display',
                    style: context.textTheme.titleMedium,
                  ),
                  Text(
                    user?.username == null ? 'unknown username' : '@${user!.username}',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                if (!isSelf)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Consumer(builder: (context, ref, _) {
                      return user?.extra?.youFollow == false
                          ? IconButton.filled(
                              onPressed: () => _follow(ref),
                              icon: const Icon(Icons.person_add),
                              iconSize: 13,
                              padding: EdgeInsets.zero,
                            )
                          : IconButton.outlined(
                              onPressed: () => _unfollow(ref),
                              icon: const Icon(Icons.person_remove),
                              iconSize: 13,
                              padding: EdgeInsets.zero,
                            );
                    }),
                  ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: SesoftProfileIcon(
                    user: user ?? const User(id: "", username: "", email: ""),
                    callProfileOnClick: false,
                    size: 25,
                    openImageOnTap: true,
                  ),
                ),
              ],
            ),
          ],
        ),
        Consumer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  user?.profile?.bio ?? 'Nada a informar na bio',
                  maxLines: 3,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.theme.colorScheme.outline,
                    fontWeight: FontWeight.bold,
                    fontSize: 9,
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => context.push(FollowsAndFollowingView.ROUTE, extra: (FollowsAndFollowingViewTab.following, user!.id)),
                      child: _ProfileHeaderInfoFollow(count: user?.followingsCount ?? 0, label: 'Seguindo'),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => context.push(FollowsAndFollowingView.ROUTE, extra: (FollowsAndFollowingViewTab.followers, user!.id)),
                      child: _ProfileHeaderInfoFollow(count: user?.followersCount ?? 0, label: 'Seguidores'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          builder: (context, ref, child) {
            return Container(
              padding: const EdgeInsets.only(top: 10),
              height: infoContainerHeight,
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(),
              child: child,
            );
          },
        )
      ],
    );
  }
}

class _ProfileHeaderInfoFollow extends StatelessWidget {
  const _ProfileHeaderInfoFollow({
    required this.count,
    required this.label,
  });

  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          count.toString(),
          style: context.textTheme.bodySmall?.copyWith(
            color: context.theme.colorScheme.outline,
            fontWeight: FontWeight.bold,
            fontSize: 9,
          ),
        ),
        const SizedBox(width: 2.5),
        Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(
            color: context.theme.colorScheme.outline,
            fontSize: 9,
          ),
        ),
      ],
    );
  }
}
